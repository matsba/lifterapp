import 'package:lifterapp/models/add_workout_state.dart';
import 'package:lifterapp/models/list_state.dart';
import 'package:lifterapp/models/log_state.dart';
import 'package:lifterapp/models/settings_state.dart';
import 'package:lifterapp/models/stats_state.dart';
import 'package:lifterapp/models/workout_group.dart';

class AppState {
  final AddWorkoutState addWorkoutState;
  final LogState logState;
  final ListState listState;
  final StatsState statsState;
  final SettingsState settingsState;

  AppState(
      {required this.addWorkoutState,
      required this.listState,
      required this.logState,
      required this.statsState,
      required this.settingsState});

  AppState.initialState()
      : addWorkoutState = AddWorkoutState.initial(),
        logState = LogState.initial(),
        listState = ListState.initial(),
        statsState = StatsState.initial(),
        settingsState = SettingsState.initial();
}
