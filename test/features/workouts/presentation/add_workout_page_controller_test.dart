import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifterapp/features/workouts/data/workouts_repository.dart';
import 'package:lifterapp/features/workouts/domain/add_workout_form.dart';
import 'package:lifterapp/features/workouts/presentation/add_workout_page.dart';
import 'package:lifterapp/features/workouts/presentation/add_workout_page_controller.dart';
import 'package:lifterapp/features/workouts/presentation/list_page_controller.dart';
import 'package:lifterapp/features/workouts/presentation/widgets/input_submit_button.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:lifterapp/features/workouts/domain/workout_set.dart';
import 'package:lifterapp/features/workouts/domain/workout.dart';
import 'package:lifterapp/features/workouts/domain/training.dart';
import 'package:lifterapp/features/workouts/domain/session.dart';
import 'package:lifterapp/features/workouts/domain/exercise.dart';

// Using mockito to keep track of when a provider notify its listeners
class Listener extends Mock {
  void call(dynamic? previous, dynamic value);
}

void main() {
  test('workoutSubmitStateProvider initial state is editing', () {
    // An object that will allow us to read providers
    // Do not share this between tests.
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final listener = Listener();

    container.listen(
      workoutSubmitStateProvider,
      listener,
      fireImmediately: true,
    );

    verify(listener(null, WorkoutSubmitState.editing)).called(1);
    verifyNoMoreInteractions(listener);
  });
}

class _MockWorkoutsRepository implements WorkoutsRepository {
  @override
  // TODO: implement db
  Database get db => throw UnimplementedError();

  @override
  Future<void> deleteSet(int id) {
    // TODO: implement deleteSet
    throw UnimplementedError();
  }

  @override
  Future<List<Exercise>> getAllExercises() async {
    // TODO: implement getAllExercises
    return [
      Exercise(
          name: "Test",
          isBodyWeigth: false,
          restingTimeBetweenSets: Duration(seconds: 60))
    ];
  }

  @override
  Future<Exercise> getExercise(int id) {
    // TODO: implement getExercise
    throw UnimplementedError();
  }

  @override
  Future<Exercise> getExerciseOrNewByName(String name) {
    // TODO: implement getExerciseOrNewByName
    throw UnimplementedError();
  }

  @override
  Future<Session?> getLatestSession() {
    // TODO: implement getLatestSession
    throw UnimplementedError();
  }

  @override
  Future<Training?> getTraining(int id) async {
    return Training(sessions: [], goalNumberOfSessionsPerWeek: 3);
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
  Future<Session> saveSession(Session session, int trainingId) {
    // TODO: implement saveSession
    throw UnimplementedError();
  }

  @override
  Future<WorkoutSet> saveSet(WorkoutSet workoutSet, int workoutId) {
    // TODO: implement saveSet
    throw UnimplementedError();
  }

  @override
  Future<Workout> saveWorkout(Workout workout, int sessionId) {
    // TODO: implement saveWorkout
    throw UnimplementedError();
  }
}
