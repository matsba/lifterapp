import 'package:lifterapp/models/workout.dart';

class AppState {
  final WorkoutGroup? latestWorkout;
  final List<WorkoutGroup> workouts;
  final List<Workout> rawWorkouts;
  final List<WorkoutCard> workoutCards;
  final WorkoutFormInput workoutFormInput;
  final List<String> workoutNames;
  final List<String> workoutNamesWithoutBodyWeigth;
  final List<OridnalWorkoutVolumes> ordinalWorkoutVolumes;
  final MonthWorkoutVolumeStatistics workoutVolumeStatistics;
  final List<int> yearWorkoutActivity;

  AppState(
      {required this.latestWorkout,
      required this.workouts,
      required this.workoutCards,
      required this.workoutFormInput,
      required this.rawWorkouts,
      required this.workoutNames,
      required this.workoutNamesWithoutBodyWeigth,
      required this.ordinalWorkoutVolumes,
      required this.workoutVolumeStatistics,
      required this.yearWorkoutActivity});

  AppState.initialState()
      : workouts = [],
        latestWorkout = null,
        workoutFormInput = WorkoutFormInput(),
        workoutCards = [],
        rawWorkouts = [],
        workoutNames = [],
        workoutNamesWithoutBodyWeigth = [],
        ordinalWorkoutVolumes = [],
        workoutVolumeStatistics =
            MonthWorkoutVolumeStatistics(acuteLoad: null, chronicLoad: null),
        yearWorkoutActivity = List.filled(52, 0);
}
