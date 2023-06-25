import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:lifterapp/features/workouts/domain/exercise.dart';
import 'package:lifterapp/features/workouts/domain/workout.dart';
import 'package:lifterapp/features/workouts/domain/workout_set.dart';

void main() {
  test('Workout simple sets formatted ...', () {
    List<WorkoutSet> sets = [
      WorkoutSet(reps: 10, timestamp: DateTime.now(), weigth: 12.5),
      WorkoutSet(reps: 10, timestamp: DateTime.now(), weigth: 12.5),
      WorkoutSet(reps: 10, timestamp: DateTime.now(), weigth: 12.5),
      WorkoutSet(reps: 10, timestamp: DateTime.now(), weigth: 12.5),
    ];

    var workout = Workout(exercise: Exercise(name: "Hauiskääntö"), sets: sets);

    var formatted = workout.formattedSets;

    expect(formatted, ["4 x 10 x 12.5 kg"]);
  });

  test('Workout complex sets formatted ...', () {
    List<WorkoutSet> sets = [
      WorkoutSet(reps: 10, timestamp: DateTime.now(), weigth: 12.5),
      WorkoutSet(reps: 9, timestamp: DateTime.now(), weigth: 12.5),
      WorkoutSet(reps: 7, timestamp: DateTime.now(), weigth: 12.5),
      WorkoutSet(reps: 7, timestamp: DateTime.now(), weigth: 12.5),
    ];

    var workout = Workout(exercise: Exercise(name: "Hauiskääntö"), sets: sets);

    var formatted = workout.formattedSets;

    expect(
        formatted, ["1 x 10 x 12.5 kg", "1 x 9 x 12.5 kg", "2 x 7 x 12.5 kg"]);
  });

  test('Workout complex sets formatted in time order ...', () {
    List<WorkoutSet> sets = [
      WorkoutSet(
          reps: 10,
          timestamp: DateTime.now().subtract(Duration(minutes: 2)),
          weigth: 12.5),
      WorkoutSet(
          reps: 9,
          timestamp: DateTime.now().subtract(Duration(minutes: 0)),
          weigth: 12.5),
      WorkoutSet(
          reps: 7,
          timestamp: DateTime.now().subtract(Duration(minutes: 1)),
          weigth: 12.5),
      WorkoutSet(
          reps: 6,
          timestamp: DateTime.now().subtract(Duration(minutes: 3)),
          weigth: 12.5),
    ];

    var workout = Workout(exercise: Exercise(name: "Hauiskääntö"), sets: sets);

    var formatted = workout.formattedSets;

    expect(formatted, [
      "1 x 6 x 12.5 kg",
      "1 x 10 x 12.5 kg",
      "1 x 7 x 12.5 kg",
      "1 x 9 x 12.5 kg"
    ]);
  });

  test('Workout complex sets formatted with different weigths ...', () {
    List<WorkoutSet> sets = [
      WorkoutSet(reps: 10, timestamp: DateTime.now(), weigth: 50),
      WorkoutSet(reps: 9, timestamp: DateTime.now(), weigth: 70),
      WorkoutSet(reps: 7, timestamp: DateTime.now(), weigth: 90),
      WorkoutSet(reps: 7, timestamp: DateTime.now(), weigth: 10),
    ];

    var workout = Workout(exercise: Exercise(name: "Hauiskääntö"), sets: sets);

    var formatted = workout.formattedSets;

    expect(formatted, [
      "1 x 10 x 50.0 kg",
      "1 x 9 x 70.0 kg",
      "1 x 7 x 90.0 kg",
      "1 x 7 x 10.0 kg"
    ]);
  });

  test('Workout get simple training volume ...', () {
    List<WorkoutSet> sets = [
      WorkoutSet(reps: 10, timestamp: DateTime.now(), weigth: 10),
      WorkoutSet(reps: 10, timestamp: DateTime.now(), weigth: 10),
      WorkoutSet(reps: 10, timestamp: DateTime.now(), weigth: 10),
      WorkoutSet(reps: 10, timestamp: DateTime.now(), weigth: 10),
    ];

    var workout = Workout(exercise: Exercise(name: "Hauiskääntö"), sets: sets);

    var volume = workout.trainingVolume;

    expect(volume, 400.0);
  });

  test('Workout get complex training volume ...', () {
    List<WorkoutSet> sets = [
      WorkoutSet(reps: 5, timestamp: DateTime.now(), weigth: 17.0),
      WorkoutSet(reps: 4, timestamp: DateTime.now(), weigth: 13.5),
      WorkoutSet(reps: 3, timestamp: DateTime.now(), weigth: 5),
      WorkoutSet(reps: 10, timestamp: DateTime.now(), weigth: 10),
    ];

    var workout = Workout(exercise: Exercise(name: "Hauiskääntö"), sets: sets);

    var volume = workout.trainingVolume;

    expect(volume, 254.0);
  });

  test('Workout get start and end times ...', () {
    List<WorkoutSet> sets = [
      WorkoutSet(
          reps: 5, timestamp: DateTime(2022, 01, 01, 01, 20), weigth: 17.0),
      WorkoutSet(
          reps: 4, timestamp: DateTime(2022, 01, 01, 01, 22), weigth: 13.5),
      WorkoutSet(reps: 3, timestamp: DateTime(2022, 01, 01, 01, 25), weigth: 5),
      WorkoutSet(
          reps: 10, timestamp: DateTime(2022, 01, 01, 01, 25, 50), weigth: 10),
    ];

    var workout = Workout(exercise: Exercise(name: "Hauiskääntö"), sets: sets);

    var startTime = workout.startTime;
    var endTime = workout.endTime;

    expect(startTime, DateTime(2022, 01, 01, 01, 20));
    expect(endTime, DateTime(2022, 01, 01, 01, 25, 50));
  });
}
