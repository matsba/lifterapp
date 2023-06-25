import 'package:lifterapp/features/statistics/domain/month_workout_volume_statistics.dart';
import 'package:lifterapp/features/statistics/domain/ordinal_workout_volume_statistics.dart';
import 'package:sqflite/sqflite.dart';

class StatisticsRepository {
  final Database db;

  StatisticsRepository({required this.db});

  Future<List<int>> getYearsWeeklyWorkouts() async {
    const currentYearQuery = "strftime('%Y', 'now', 'localtime')";
    const numberOfWeeks = 52;
    const query = """SELECT strftime('%W', timestamp) AS weeknum,
                            count(DISTINCT strftime('%d', timestamp) ) AS dayCount
                        FROM session
                      WHERE strftime('%Y', timestamp) = $currentYearQuery
                      GROUP BY weeknum;""";

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

  Future<List<OridnalWorkoutVolume>> getOridnalWorkoutVolumes(
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
                                                  exercise.name,
                                                  sets.timestamp,
                                                  COUNT( * ) * sets.reps * sets.weigth AS volume
                                            FROM workout
                                            JOIN exercise on workout.fk_exercise_id = exercise.id
                                            JOIN sets on sets.fk_workout_id = workout.id
                                            WHERE ${filterOrAll == "Kaikki" ? "exercise.is_body_weigth = 0" : "exercise.name = '$filter' AND exercise.is_body_weigth = 0"}
                                            GROUP BY yearDt,
                                                    weeknum,
                                                    dayDt,
                                                    exercise.name,
                                                    sets.timestamp
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

    return queryResult
        .map((x) => OridnalWorkoutVolume.fromMap(x, filterOrAll))
        .toList();
  }

  Future<MonthWorkoutVolume> getMonthWorkoutStats() async {
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
    it means your body can probably handle going heavier. 
    
    See also https://www.muscleandstrength.com/articles/beyond-sets-and-reps-look-at-training-volume.html
    */

    const acuteLoadQuery = """
           SELECT SUM(volume) AS volume
           FROM (
           SELECT exercise.name,
                  count( * ) * sets.reps * sets.weigth AS volume
             FROM workout
                  JOIN
                  exercise ON workout.fk_exercise_id = exercise.id
                  JOIN
                  sets ON sets.fk_workout_id = workout.id
            WHERE strftime(sets.timestamp) >= date('now', '-7 days') AND 
                  exercise.is_body_weigth = 0
            GROUP BY exercise.name
       );""";

    const chronicLoadQuery = """
          SELECT sum(volume) / 4 as chronic
          FROM (
            SELECT strftime('%W',sets.timestamp) AS weeknum, exercise.name, count(*) * sets.reps * sets.weigth as volume
            FROM workout
                  JOIN
                  exercise ON workout.fk_exercise_id = exercise.id
                  JOIN
                  sets ON sets.fk_workout_id = workout.id               
            WHERE strftime(timestamp) >= date('now','-28 days') AND 
            exercise.is_body_weigth = 0
            GROUP BY weeknum, exercise.name
            ORDER BY sets.timestamp DESC);""";

    var acuteLoadResult = await db.rawQuery(acuteLoadQuery);
    var chronicLoadResult = await db.rawQuery(chronicLoadQuery);

    return MonthWorkoutVolume(
        acuteLoad: acuteLoadResult.first["volume"] != null
            ? double.parse(acuteLoadResult.first["volume"].toString())
            : null,
        chronicLoad: chronicLoadResult.first["chronic"] != null
            ? double.parse(chronicLoadResult.first["chronic"].toString())
            : null);
  }
}
