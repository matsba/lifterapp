import 'package:lifterapp/models/workout.dart'
    show Workout, WorkoutCard, WorkoutFormInput, WorkoutGroup;

class AppState {
  final WorkoutGroup? latestWorkout;
  final List<WorkoutGroup> workouts;
  final List<Workout> rawWorkouts;
  final List<WorkoutCard> workoutCards;
  final WorkoutFormInput workoutFormInput;
  //List<Workout> get workouts => _workouts;

  AppState(
      {required this.latestWorkout,
      required this.workouts,
      required this.workoutCards,
      required this.workoutFormInput,
      required this.rawWorkouts});

  AppState.initialState()
      : workouts = [],
        latestWorkout = null,
        workoutFormInput = WorkoutFormInput(),
        workoutCards = [],
        rawWorkouts = [];
}
