import 'package:lifterapp/models/workout_form_input.dart';
import 'package:lifterapp/models/workout_group.dart';
import 'package:flutter/material.dart';

@immutable
class AddWorkoutState {
  final WorkoutFormInput workoutFormInput;
  final WorkoutGroup? latestWorkout;
  final Duration? restingTime;

  AddWorkoutState(
      {required this.workoutFormInput,
      required this.latestWorkout,
      required this.restingTime});

  AddWorkoutState.initial()
      : latestWorkout = null,
        workoutFormInput = WorkoutFormInput(),
        restingTime = null;

  AddWorkoutState copyWith({
    WorkoutFormInput? workoutFormInput,
    WorkoutGroup? latestWorkout,
    Duration? restingTime,
  }) {
    return AddWorkoutState(
        workoutFormInput: workoutFormInput ?? this.workoutFormInput,
        latestWorkout: latestWorkout ?? this.latestWorkout,
        restingTime: restingTime ?? this.restingTime);
  }
}
