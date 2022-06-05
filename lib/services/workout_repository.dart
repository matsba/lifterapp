import 'package:lifterapp/models/month_workout_volume_statistics.dart';
import 'package:lifterapp/models/ordinal_workout_volumes.dart';
import 'package:lifterapp/models/workout_card.dart';
import 'package:lifterapp/models/workout_group.dart';
import 'package:lifterapp/services/service_locator.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lifterapp/models/workout.dart';
import 'dart:async';

class WorkoutRepository {
  Database db = getIt.get<Database>();

  Future insert(Workout workout) async {
    await db.insert('workouts', workout.toMap());
  }

  Future replaceAllWorkoutsWithList(List<Workout> workouts) async {
    await db.transaction((txn) async {
      final batch = txn.batch();
      db.delete('workouts');
      for (var workout in workouts) {
        db.insert('workouts', workout.toMap());
      }
      await batch.commit();
    });
  }

  Future<List<Workout>> getAll() async {
    final List<Map<String, Object?>> queryResult = await db.query('workouts');
    return queryResult.map((e) => Workout.fromMap(e)).toList();
  }

  Future<List<WorkoutGroup>> getAllGroups() async {
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        """SELECT year, month, day, name, reps, weigth, count(*) as sets, avg(body_weigth) as body_weigth, GROUP_CONCAT(timestamp) as timestamps
                                    FROM workouts 
                                    GROUP BY year, month, day, name, reps, weigth 
                                    ORDER BY timestamp DESC""");
    return queryResult.map((e) => WorkoutGroup.fromMap(e)).toList();
  }

  Future<List<String>> getWorkoutNames() async {
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        """SELECT DISTINCT name FROM workouts WHERE name != "" AND name IS NOT NULL ORDER BY name ASC""");

    return queryResult.map((e) => e["name"].toString()).toList();
  }

  Future<List<String>> getWorkoutNamesWithoutBodyWeigth() async {
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        """SELECT DISTINCT name FROM workouts WHERE name != "" AND name IS NOT NULL and body_weigth = 0 ORDER BY name ASC""");

    return queryResult.map((e) => e["name"].toString()).toList();
  }

  Future<WorkoutGroup?> getLatestGroup() async {
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        """SELECT year, month, day, name, reps, weigth, count(*) as sets, avg(body_weigth) as body_weigth, GROUP_CONCAT(timestamp) as timestamps
                                    FROM workouts 
                                    GROUP BY year, month, day, name, reps, weigth 
                                    ORDER BY timestamp DESC
                                    LIMIT 1""");
    if (queryResult.isEmpty) {
      return null;
    }
    return queryResult.map((e) => WorkoutGroup.fromMap(e)).single;
  }

  Future<List<WorkoutCard>> getAllCards() async {
    List<WorkoutGroup> groups = await getAllGroups();
    List<WorkoutCard> cards = [];
    List<String> uniqueDates = groups.map((x) => x.dateFormat).toSet().toList();

    for (var date in uniqueDates) {
      var workouts = groups.where((x) => x.dateFormat == date).toList();

      cards.add(WorkoutCard(date: date, workouts: workouts));
    }

    return cards;
  }

  Future<List<OridnalWorkoutVolumes>> getOridnalWorkoutVolumes(
      {String? filter}) async {
    String filterOrAll = filter ?? "Kaikki";

    String query = """
          SELECT yearC AS year,
                weeknumC AS weeknum,
                SUM(volume) AS volume
            FROM (
                WITH RECURSIVE cte AS (
                        SELECT DATE('now') AS dt,
                                DATE( (
                                          SELECT TIMESTAMP
                                            FROM workouts
                                          ORDER BY TIMESTAMP ASC
                                          LIMIT 1
                                      )
                                ) AS last_dt
                        UNION ALL
                        SELECT DATE(dt, '-1 day'),
                                last_dt
                          FROM cte
                          WHERE dt > last_dt
                    )
                    SELECT strftime('%Y', dt) AS yearC,
                            strftime('%W', dt) AS weeknumC,
                            strftime('%d', dt) AS dayC,
                            IFNULL(w.volume, 0) AS volume
                      FROM cte c-- join values to zero values
                            LEFT JOIN
                            (
                                SELECT yearDt,
                                      weeknum,
                                      dayDt,-- sum in out clause because limitation with using count
                                      SUM(volume) AS volume
                                  FROM (
                                          SELECT strftime('%Y', TIMESTAMP) AS yearDt,
                                                  strftime('%W', TIMESTAMP) AS weeknum,
                                                  strftime('%d', TIMESTAMP) AS dayDt,
                                                  name,
                                                  TIMESTAMP,
                                                  COUNT( * ) * reps * weigth AS volume
                                            FROM workouts-- filter if needed
                                            WHERE ${filterOrAll == "Kaikki" ? "body_weigth = 0" : "name = '$filter' AND body_weigth = 0"}

                                            GROUP BY yearDt,
                                                    weeknum,
                                                    dayDt,
                                                    name,
                                                    TIMESTAMP
                                      )
                                GROUP BY yearDt,
                                          weeknum,
                                          dayDt
                            )
                            w ON w.weeknum = weeknumC AND 
                                w.yearDt = yearC AND 
                                w.dayDt = dayC
                      GROUP BY yearC,
                              weeknumC,
                              dayC
                      ORDER BY yearC,
                              weeknumC,
                              dayC ASC
                )
          GROUP BY year,
                    weeknum
          ORDER BY year,
                    weeknum;
            """;
    List<Map<String, Object?>> queryResult = await db.rawQuery(query);

    if (queryResult.every((element) => element["volume"] == 0)) {
      return [];
    }

    formatGroupName(var queryResultItem) {
      return "${queryResultItem["weeknum"]}/${queryResultItem["year"].toString().substring(2, 4)}";
    }

    return queryResult
        .map((x) => OridnalWorkoutVolumes(filterOrAll, formatGroupName(x),
            double.parse(x["volume"].toString())))
        .toList();
  }

  Future<MonthWorkoutVolumeStatistics> getMonthWorkoutStats() async {
/*  Start by finding your total volume in the past week (aka your "acute load"). 
    Remember, your training volume = sets x reps x weight used. So, if on Monday, 
    Wednesday, and Friday you completed: 3 sets of 8 reps of squats at 100lbs and 
    4 sets of 8 reps of bench press 4 sets of 8 at 50lbs, your squat training volume
    is 3 x 8 x 100 = 2,400 daily volume x 3 workouts = 7,200 weekly volume. 
    And your bench press volume is 4 x 8 x 50 = 1,600 daily volume x 3 workouts = 4,800 
    weekly volume. Added together, you get 12,000, which is your acute load.

    Divide the "acute load" by your average volume over the past four weeks 
    (aka your "chronic load"). To find your chronic load, calculate your acute 
    load using the above formula for each of the last four weeks. Add those values together, 
    then divide by four to find the average. This value is your chronic load. 
    For the purposes of the example, let's assume that your average volume 
    (chronic load) is 11,000.

    Divide the acute load by the chronic load to get a ratio. In this example,
    the acute load divided by chronic load is 12,000 divided by 11,000 = 1.09.

    Cool... so what does that value mean?? "Researchers found that the 'sweet spot' 
    for training is a ratio between .8 and 1.3 and that anything over 1.5 significantly 
    increases your risk for injury," says Mack.

    So, if you get a value that is higher than 1.5, it means you should cut down on 
    your current volume (or maybe the volume of a planned workout) either by dropping 
    the weight, reps, or number of sets, she says.  And if you get a value lower than .8, 
    it means your body can probably handle going heavier. */

    const acuteLoadQuery =
        """SELECT SUM(volume) as volume FROM (SELECT name, count(*) * reps * weigth as volume 
           FROM workouts
           WHERE strftime(timestamp) >= date('now','-7 days') AND body_weigth = 0
           GROUP BY name);""";

    const chronicLoadQuery = """SELECT sum(volume) / 4 as chronic
          FROM (
            SELECT strftime('%W',timestamp) AS weeknum, name, count(*) * reps * weigth as volume
            FROM workouts               
            WHERE strftime(timestamp) >= date('now','-28 days') AND body_weigth = 0
            GROUP BY weeknum, name
            ORDER BY timestamp DESC
          )""";

    var acuteLoadResult = await db.rawQuery(acuteLoadQuery);
    var chronicLoadResult = await db.rawQuery(chronicLoadQuery);

    return MonthWorkoutVolumeStatistics(
        acuteLoad: acuteLoadResult.first["volume"] != null
            ? double.parse(acuteLoadResult.first["volume"].toString())
            : null,
        chronicLoad: chronicLoadResult.first["chronic"] != null
            ? double.parse(chronicLoadResult.first["chronic"].toString())
            : null);
  }

  Future<List<int>> getYearsWeeklyWorkouts() async {
    const currentYearQuery = "strftime('%Y', 'now', 'localtime')";
    const numberOfWeeks = 52;
    const query =
        """SELECT strftime('%W',timestamp) AS weeknum, count(distinct DAY) as dayCount 
           FROM workouts
           WHERE year = $currentYearQuery
           GROUP BY weeknum
           ORDER BY timestamp ASC;""";

    int getDayCountForWeek(
        int weeknum, List<Map<String, Object?>> weekDayCountsQueryResult) {
      return int.parse(weekDayCountsQueryResult
          .singleWhere(
              (element) => int.parse(element["weeknum"].toString()) == weeknum,
              orElse: () => {"dayCount": 0})["dayCount"]
          .toString());
    }

    var queryResult = await db.rawQuery(query);

    var weekList = List.filled(numberOfWeeks, 0);

    for (var i = 0; i < weekList.length; i++) {
      weekList[i] = getDayCountForWeek(i, queryResult);
    }
    return weekList;
  }

  Future deleteWorkout(int id) async {
    await db.delete(
      'workouts',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
