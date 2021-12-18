import 'package:lifterapp/common/database_util.dart';
import 'package:sqflite/sqflite.dart'
    show Database, getDatabasesPath, openDatabase;
import 'package:path/path.dart' show join;
import 'package:lifterapp/models/workout.dart'
    show Workout, WorkoutCard, WorkoutGroup, WorkoutMinimal;
import 'dart:async' show Future;

class WorkoutRepository {
  final Future<Database> _db = DatabaseUtil().db;

  Future<int> insert(Workout workout) async {
    int result = 0;
    final Database dbContact = await _db;
    result = await dbContact.insert('workouts', workout.toMap());
    return result;
  }

  Future<List<Workout>> getAll() async {
    final Database dbContact = await _db;
    final List<Map<String, Object?>> queryResult =
        await dbContact.query('workouts');
    print(queryResult.toString());
    return queryResult.map((e) => Workout.fromMap(e)).toList();
  }

  Future<List<WorkoutGroup>> getAllGroups() async {
    final Database dbContact = await _db;
    final List<Map<String, Object?>> queryResult = await dbContact.rawQuery(
        """SELECT year, month, day, name, reps, weigth, count(*) as sets, avg(body_weigth) as body_weigth, GROUP_CONCAT(timestamp) as timestamps
                                    FROM workouts 
                                    GROUP BY year, month, day, name, reps, weigth 
                                    ORDER BY timestamp DESC""");
    print("group got: ");
    print(queryResult.toString());
    return queryResult.map((e) => WorkoutGroup.fromMap(e)).toList();
  }

  Future<WorkoutGroup?> getLatestGroup() async {
    final Database dbContact = await _db;
    final List<Map<String, Object?>> queryResult = await dbContact.rawQuery(
        """SELECT year, month, day, name, reps, weigth, count(*) as sets, avg(body_weigth) as body_weigth, GROUP_CONCAT(timestamp) as timestamps
                                    FROM workouts 
                                    GROUP BY year, month, day, name, reps, weigth 
                                    ORDER BY timestamp DESC
                                    LIMIT 1""");
    print("1 group got: ");
    print(queryResult.toString());
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
      var workouts = groups
          .where((x) => x.dateFormat == date)
          .map((x) => WorkoutMinimal(
              name: x.name,
              setsRepsWeigth: x.setFormat,
              timestamps: x.timestampsInListFormat,
              bodyWeigth: x.bodyWeigth))
          .toList();

      cards.add(WorkoutCard(date: date, workouts: workouts));
    }

    return cards;
  }
  //weigthlifted
  //SELECT year, month, day, name, SUM(weigth)  * reps as weigthLifted FROM workouts GROUP BY year, month, day, name ORDER BY timestamp DESC;;

  Future<void> deleteWorkout(int id) async {
    final dbContact = await _db;
    await dbContact.delete(
      'workouts',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
