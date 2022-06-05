import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:lifterapp/models/month_workout_volume_statistics.dart';
import 'package:lifterapp/models/ordinal_workout_volumes.dart';
import 'package:lifterapp/models/workout.dart';
import 'package:lifterapp/services/service_locator.dart';
import 'package:lifterapp/services/workout_repository.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

main() async {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    print("Testing Workout Repository");
  });

  group("Happy cases", () {
    setUp(() async {
      //Use sql file to initate database for tests
      var pathToFile = "test/assets/lifterapp_test.sql";
      var sqlQuery =
          await File(join(dirname(Platform.script.toFilePath()), pathToFile))
              .readAsString();
      Database db = await databaseFactory.openDatabase(inMemoryDatabasePath);
      await db.execute(sqlQuery);

      //Dependency injection for db
      getIt.registerSingleton(db, dispose: (Database db) => db.close());
    });

    test('getAll()', () async {
      //ASSEMBLE
      var repo = WorkoutRepository();

      //ARRANGE
      var result = await repo.getAll();

      //ASSERT
      expect(result.length, 26);
    });

    test('getAllGroups()', () async {
      //ASSEMBLE
      var repo = WorkoutRepository();

      //ARRANGE
      var result = await repo.getAllGroups();

      //ASSERT
      expect(result.length, 13);
    });

    test('getWorkoutNames()', () async {
      //ASSEMBLE
      var repo = WorkoutRepository();

      //ARRANGE
      var result = await repo.getWorkoutNames();

      //ASSERT
      expect(result.toSet(), {
        "Hauiskääntö",
        "Penkki käsipainoilla",
        "Ylätalja kapealla kahvalla",
        "Vatsat",
        "Kyykky tangolla",
        "Selkä"
      });
    });

    test('getWorkoutNamesWithoutBodyWeigth()', () async {
      //ASSEMBLE
      var repo = WorkoutRepository();

      //ARRANGE
      var result = await repo.getWorkoutNamesWithoutBodyWeigth();

      //ASSERT
      expect(result.toSet(), {
        "Hauiskääntö",
        "Penkki käsipainoilla",
        "Ylätalja kapealla kahvalla",
        "Kyykky tangolla",
        "Selkä"
      });
    });

    test('getOridnalWorkoutVolumes() with all filter', () async {
      //ASSEMBLE
      var repo = WorkoutRepository();

      //ARRANGE
      List<OridnalWorkoutVolumes> result =
          await repo.getOridnalWorkoutVolumes();
      var week19 = result.firstWhere((element) => element.group == "19/22");
      var week20 = result.firstWhere((element) => element.group == "20/22");

      //ASSERT
      expect(week19.name, "Kaikki");
      expect(week20.name, "Kaikki");
      expect(week19.volume, 1620.0);
      expect(week20.volume, 3842.5);
    });

    test('getOridnalWorkoutVolumes() with Hauiskääntö filter', () async {
      //ASSEMBLE
      var repo = WorkoutRepository();

      //ARRANGE
      List<OridnalWorkoutVolumes> result =
          await repo.getOridnalWorkoutVolumes(filter: "Hauiskääntö");
      var week19 = result.firstWhere((element) => element.group == "19/22");
      var week20 = result.firstWhere((element) => element.group == "20/22");

      //ASSERT
      expect(week19.name, "Hauiskääntö");
      expect(week20.name, "Hauiskääntö");
      expect(week19.volume, 720.0);
      expect(week20.volume, 162.5);
    });

    test('getYearsWeeklyWorkouts()', () async {
      //ASSEMBLE
      var repo = WorkoutRepository();

      //ARRANGE
      var result = await repo.getYearsWeeklyWorkouts();
      var week19 = result[19];
      var week20 = result[20];

      //ASSERT
      expect(result.length, 52);
      expect(week19, 2);
      expect(week20, 3);
      expect(result.where((element) => element == 0).length, 50);
    });

    List<Workout> generateWorkoutsForMonthlyStats(
        {required DateTime fromDate, required int workoutTimesPerWeek}) {
      const testWorkouts = ["Hauiskääntö", "Ylätalja", "Penkki", "Kyykky"];
      List<Workout> workouts = [];

      for (var dt in List.generate(
          workoutTimesPerWeek * 4,
          (index) => fromDate.subtract(
              Duration(days: (index * (7 / workoutTimesPerWeek)).toInt())))) {
        for (var workoutName in testWorkouts) {
          Workout workout = Workout(
              name: workoutName,
              bodyWeigth: false,
              reps: 4,
              weigth: 10,
              timestamp: dt);

          workouts.addAll(List.filled(4, workout));
        }
      }
      return workouts;
    }

    test('getMonthWorkoutStats() for 3 times a week', () async {
      //ASSEMBLE
      var repo = WorkoutRepository();
      await repo.replaceAllWorkoutsWithList(generateWorkoutsForMonthlyStats(
          fromDate: DateTime.now(), workoutTimesPerWeek: 3));

      //ARRANGE
      MonthWorkoutVolumeStatistics result = await repo.getMonthWorkoutStats();

      //ASSERT
      expect(result.acuteLoad, 1920);
      expect(result.chronicLoad, 7680 / 4);
      expect(result.ratio, result.acuteLoad! / result.chronicLoad!);
    }, skip: true);

    test("deleteWorkout()", () async {
      //ASSEMBLE
      Database db = getIt.get<Database>();
      var repo = WorkoutRepository();

      //ARRANGE
      await repo.deleteWorkout(817);
      var foundDeletedWorkout = await db.query("workouts", where: "id = 817");

      //ASSERT
      expect(foundDeletedWorkout, []);
    });

    //Tear down after each test to avoid using same db
    tearDown(() async => await getIt.reset());
  });
}
