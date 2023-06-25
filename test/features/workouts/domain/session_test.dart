import 'package:flutter_test/flutter_test.dart';
import 'package:lifterapp/features/workouts/domain/exercise.dart';
import 'package:lifterapp/features/workouts/domain/session.dart';
import 'package:lifterapp/features/workouts/domain/workout.dart';
import 'package:lifterapp/features/workouts/domain/workout_set.dart';

void main() {
  test('Session get training volume...', () {
    var workouts = [
      Workout(exercise: Exercise(name: "Hauiskääntö"), sets: [
        //500 volume
        WorkoutSet(
            reps: 10, timestamp: DateTime(2022, 01, 01, 10, 00), weigth: 12.5),
        WorkoutSet(
            reps: 10, timestamp: DateTime(2022, 01, 01, 10, 01), weigth: 12.5),
        WorkoutSet(
            reps: 10, timestamp: DateTime(2022, 01, 01, 10, 02), weigth: 12.5),
        WorkoutSet(
            reps: 10, timestamp: DateTime(2022, 01, 01, 10, 03), weigth: 12.5),
      ]),
      Workout(exercise: Exercise(name: "Kyykky tangolla"), sets: [
        //2000 volume
        WorkoutSet(
            reps: 10, timestamp: DateTime(2022, 01, 01, 10, 04), weigth: 50),
        WorkoutSet(
            reps: 10, timestamp: DateTime(2022, 01, 01, 10, 06), weigth: 50),
        WorkoutSet(
            reps: 10, timestamp: DateTime(2022, 01, 01, 10, 08), weigth: 50),
        WorkoutSet(
            reps: 10, timestamp: DateTime(2022, 01, 01, 10, 10), weigth: 50),
      ]),
      Workout(exercise: Exercise(name: "Penkki käsipainoilla"), sets: [
        //600 volume
        WorkoutSet(
            reps: 10, timestamp: DateTime(2022, 01, 01, 10, 20), weigth: 15),
        WorkoutSet(
            reps: 10, timestamp: DateTime(2022, 01, 01, 10, 22), weigth: 15),
        WorkoutSet(
            reps: 10, timestamp: DateTime(2022, 01, 01, 10, 24), weigth: 15),
        WorkoutSet(
            reps: 10, timestamp: DateTime(2022, 01, 01, 10, 26), weigth: 15),
      ]),
    ];

    Session session =
        Session(timestamp: DateTime(2022, 01, 01, 10, 00), workouts: workouts);

    var volume = session.trainingVolume;

    expect(volume, 3100);
  });
}
