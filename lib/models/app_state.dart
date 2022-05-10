import 'package:lifterapp/models/add_workout_state.dart';
import 'package:lifterapp/models/list_state.dart';
import 'package:lifterapp/models/log_state.dart';
import 'package:lifterapp/models/stats_state.dart';
import 'package:lifterapp/models/workout_group.dart';

class AppState {
  final AddWorkoutState addWorkoutState;
  final LogState logState;
  final ListState listState;
  final StatsState statsState;

  //Not used?
  // final List<String> workoutNames;
  // final List<WorkoutGroup> workouts;

  AppState({
    required this.addWorkoutState,
    // required this.workouts,
    required this.listState,
    required this.logState,
    // required this.workoutNames,
    required this.statsState,
  });

  AppState.initialState()
      : addWorkoutState = AddWorkoutState.initial(),
        logState = LogState.initial(),
        listState = ListState.initial(),
        statsState = StatsState.initial();
  // workoutNames = [],
  // workouts = [];
}
