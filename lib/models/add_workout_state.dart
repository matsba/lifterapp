import 'package:lifterapp/models/workout_form_input.dart';
import 'package:lifterapp/models/workout_group.dart';
import 'package:meta/meta.dart';

@immutable
class AddWorkoutState {
  final WorkoutFormInput workoutFormInput;
  final WorkoutGroup? latestWorkout;

  AddWorkoutState(
      {required this.workoutFormInput, required this.latestWorkout});

  AddWorkoutState.initial()
      : latestWorkout = null,
        workoutFormInput = WorkoutFormInput();

  AddWorkoutState copyWith({
    WorkoutFormInput? workoutFormInput,
    WorkoutGroup? latestWorkout,
  }) {
    return AddWorkoutState(
      workoutFormInput: workoutFormInput ?? this.workoutFormInput,
      latestWorkout: latestWorkout ?? this.latestWorkout,
    );
  }
}
