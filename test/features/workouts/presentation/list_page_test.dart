import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifterapp/features/workouts/data/workouts_repository.dart';
import 'package:lifterapp/features/workouts/presentation/list_page.dart';
import 'package:lifterapp/features/workouts/presentation/list_page_controller.dart';
import 'package:lifterapp/features/workouts/domain/workout_set.dart';
import 'package:lifterapp/features/workouts/domain/workout.dart';
import 'package:lifterapp/features/workouts/domain/training.dart';
import 'package:lifterapp/features/workouts/domain/session.dart';
import 'package:lifterapp/features/workouts/domain/exercise.dart';
import 'package:sqflite/sqlite_api.dart';

void main() async {
  testWidgets('On list page finds workout from list at the bottom session',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          workoutsRepositoryProvider
              .overrideWithValue(_MockWorkoutsRepository())
        ],
        child: MaterialApp(home: ListPage()),
      ),
    );

    // Wait for all the animations to finish
    await tester.pumpAndSettle();

    //find the list and the scrollable inside it
    final list = find.byKey(const Key("session_list"));
    final scrollable = find.byWidgetPredicate((w) => w is Scrollable);
    final scrollableOfList =
        find.descendant(of: list, matching: scrollable).first;

    final findWorkoutTitle = find.byKey(const Key("Hauiskääntö_1"));

    await tester.scrollUntilVisible(findWorkoutTitle, 200.0,
        scrollable: scrollableOfList);
    await tester.pump();

    expect(findWorkoutTitle, findsOneWidget);
  });
}

class _MockWorkoutsRepository implements WorkoutsRepository {
  @override
  Database get db => throw UnimplementedError();

  @override
  Future<void> deleteSet(int id) {
    throw UnimplementedError();
  }

  @override
  Future<List<Exercise>> getAllExercises() {
    throw UnimplementedError();
  }

  @override
  Future<Exercise> getExercise(int id) {
    throw UnimplementedError();
  }

  @override
  Future<Exercise> getExerciseOrNewByName(String name) {
    throw UnimplementedError();
  }

  @override
  Future<Session?> getLatestSession() {
    throw UnimplementedError();
  }

  @override
  Future<Training?> getTraining(int id) async {
    var workoutToFind = Workout.fromMap({
      "id": 1,
      "fk_session_id": 1
    }, [
      //500 volume
      WorkoutSet(
          reps: 10, timestamp: DateTime(2022, 01, 03, 10, 00), weigth: 12.5),
      WorkoutSet(
          reps: 10, timestamp: DateTime(2022, 01, 03, 10, 01), weigth: 12.5),
      WorkoutSet(
          reps: 10, timestamp: DateTime(2022, 01, 03, 10, 02), weigth: 12.5),
      WorkoutSet(
          reps: 10, timestamp: DateTime(2022, 01, 03, 10, 03), weigth: 12.5),
    ], Exercise(name: "Hauiskääntö"));
    var sessions = [
      Session(
        timestamp: DateTime(2022, 01, 01, 10, 00),
        workouts: [
          workoutToFind,
          Workout(exercise: Exercise(name: "Kyykky tangolla"), sets: [
            //2000 volume
            WorkoutSet(
                reps: 10,
                timestamp: DateTime(2022, 01, 01, 10, 04),
                weigth: 50),
            WorkoutSet(
                reps: 10,
                timestamp: DateTime(2022, 01, 01, 10, 06),
                weigth: 50),
            WorkoutSet(
                reps: 10,
                timestamp: DateTime(2022, 01, 01, 10, 08),
                weigth: 50),
            WorkoutSet(
                reps: 10,
                timestamp: DateTime(2022, 01, 01, 10, 10),
                weigth: 50),
          ]),
          Workout(exercise: Exercise(name: "Penkki käsipainoilla"), sets: [
            //600 volume
            WorkoutSet(
                reps: 10,
                timestamp: DateTime(2022, 01, 01, 10, 20),
                weigth: 15),
            WorkoutSet(
                reps: 10,
                timestamp: DateTime(2022, 01, 01, 10, 22),
                weigth: 15),
            WorkoutSet(
                reps: 10,
                timestamp: DateTime(2022, 01, 01, 10, 24),
                weigth: 15),
            WorkoutSet(
                reps: 10,
                timestamp: DateTime(2022, 01, 01, 10, 26),
                weigth: 15),
          ]),
        ],
      ),
      Session(
        timestamp: DateTime(2022, 01, 03, 10, 00),
        workouts: [
          Workout(exercise: Exercise(name: "Workout 1"), sets: [
            //2000 volume
            WorkoutSet(
                reps: 10,
                timestamp: DateTime(2022, 01, 03, 10, 04),
                weigth: 50),
            WorkoutSet(
                reps: 10,
                timestamp: DateTime(2022, 01, 03, 10, 06),
                weigth: 50),
            WorkoutSet(
                reps: 10,
                timestamp: DateTime(2022, 01, 03, 10, 08),
                weigth: 50),
            WorkoutSet(
                reps: 10,
                timestamp: DateTime(2022, 01, 03, 10, 10),
                weigth: 50),
          ]),
          Workout(exercise: Exercise(name: "Workout 2"), sets: [
            //450 volume
            WorkoutSet(
                reps: 10,
                timestamp: DateTime(2022, 01, 03, 10, 20),
                weigth: 15),
            WorkoutSet(
                reps: 10,
                timestamp: DateTime(2022, 01, 03, 10, 22),
                weigth: 15),
            WorkoutSet(
                reps: 5, timestamp: DateTime(2022, 01, 03, 10, 24), weigth: 15),
            WorkoutSet(
                reps: 5, timestamp: DateTime(2022, 01, 03, 10, 26), weigth: 15),
          ]),
        ],
      )
    ];

    return Training(sessions: sessions, goalNumberOfSessionsPerWeek: 3);
  }

  @override
  Future<Exercise?> getExerciseByName(String name) {
    // TODO: implement getExerciseByName
    throw UnimplementedError();
  }

  @override
  Future<Exercise> saveExercise(Exercise exercise) {
    // TODO: implement saveExercise
    throw UnimplementedError();
  }

  @override
  Future<Session> saveSession(Session session, int id) {
    // TODO: implement saveSession
    throw UnimplementedError();
  }

  @override
  Future<WorkoutSet> saveSet(WorkoutSet workoutSet, int id) {
    // TODO: implement saveSet
    throw UnimplementedError();
  }

  @override
  Future<Workout> saveWorkout(Workout workout, int id) {
    // TODO: implement saveWorkout
    throw UnimplementedError();
  }
}
