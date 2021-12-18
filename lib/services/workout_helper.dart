import 'package:sqflite/sqflite.dart'
    show Database, getDatabasesPath, openDatabase;
import 'package:path/path.dart' show join;
import 'package:lifterapp/models/workout.dart'
    show Workout, WorkoutCard, WorkoutGroup, WorkoutMinimal;
import 'dart:async' show Future;

class WorkoutHelper {
  static final WorkoutHelper _instance = WorkoutHelper.internal();
  factory WorkoutHelper() => _instance;
  WorkoutHelper.internal();
  late Database _db;

  Future<Database> get db async {
    await initDb();
    return _db;
  }

  Future<void> initDb() async {
    String path = await getDatabasesPath();
    Future<Database> connection = openDatabase(
      join(path, 'lifterapp.db'),
      onCreate: (database, version) async {
        await database.execute("""CREATE TABLE workouts(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            name TEXT, 
            reps INTEGER, 
            weigth REAL, 
            timestamp TEXT, 
            year INTEGER, 
            month INTEGER, 
            day INTEGER)""");
      },
      version: 1,
    );
    _db = await connection;
  }

  Future<int> insertWorkout(Workout workout) async {
    int result = 0;
    final Database dbContact = await db;
    result = await dbContact.insert('workouts', workout.toMap());
    return result;
  }

  Future<List<Workout>> getWorkouts() async {
    final Database dbContact = await db;
    final List<Map<String, Object?>> queryResult =
        await dbContact.query('workouts');
    print(queryResult.toString());
    return queryResult.map((e) => Workout.fromMap(e)).toList();
  }

  Future<List<WorkoutGroup>> getWorkoutGroups() async {
    final Database dbContact = await db;
    final List<Map<String, Object?>> queryResult = await dbContact.rawQuery(
        """SELECT year, month, day, name, reps, weigth, count(*) as sets 
                                    FROM workouts 
                                    GROUP BY year, month, day, name, reps, weigth 
                                    ORDER BY timestamp DESC""");
    print("group got: ");
    print(queryResult.toString());
    return queryResult.map((e) => WorkoutGroup.fromMap(e)).toList();
  }

  Future<WorkoutGroup> getLatestWorkoutGroup() async {
    final Database dbContact = await db;
    final List<Map<String, Object?>> queryResult = await dbContact.rawQuery(
        """SELECT year, month, day, name, reps, weigth, count(*) as sets 
                                    FROM workouts 
                                    GROUP BY year, month, day, name, reps, weigth 
                                    ORDER BY timestamp DESC
                                    LIMIT 1""");
    print("1 group got: ");
    print(queryResult.toString());
    return queryResult.map((e) => WorkoutGroup.fromMap(e)).single;
  }

  Future<List<WorkoutCard>> getWorkoutCards() async {
    List<WorkoutGroup> groups = await getWorkoutGroups();
    List<WorkoutCard> cards = [];
    List<String> uniqueDates = groups.map((x) => x.dateFormat).toSet().toList();

    for (var date in uniqueDates) {
      var workouts = groups
          .where((x) => x.dateFormat == date)
          .map((x) => WorkoutMinimal(
              name: x.name,
              setsRepsWeigth: x.setFormat,
              timestamps: x.timestampsInListFormat))
          .toList();

      cards.add(WorkoutCard(date: date, workouts: workouts));
    }

    return cards;
  }
  //weigthlifted
  //SELECT year, month, day, name, SUM(weigth)  * reps as weigthLifted FROM workouts GROUP BY year, month, day, name ORDER BY timestamp DESC;;

  Future<void> deleteWorkout(int id) async {
    final dbContact = await db;
    await dbContact.delete(
      'workouts',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
