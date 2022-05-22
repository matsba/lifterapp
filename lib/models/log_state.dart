import 'package:lifterapp/models/workout.dart';
import 'package:flutter/material.dart';

@immutable
class LogState {
  final List<Workout> rawWorkouts;

  LogState({required this.rawWorkouts});

  LogState.initial() : rawWorkouts = [];

  copyWith({List<Workout>? rawWorkouts}) =>
      LogState(rawWorkouts: rawWorkouts ?? this.rawWorkouts);
}
