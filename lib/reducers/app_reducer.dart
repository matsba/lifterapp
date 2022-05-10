import 'package:lifterapp/models/app_state.dart';
import 'package:lifterapp/reducers/add_workout_reducer.dart';
import 'package:lifterapp/reducers/list_reducer.dart';
import 'package:lifterapp/reducers/log_reducer.dart';
import 'package:lifterapp/reducers/stats_reducer.dart';

AppState appReducer(AppState state, dynamic action) => AppState(
    addWorkoutState: addWorkoutReducer(state.addWorkoutState, action),
    listState: listReducer(state.listState, action),
    logState: logReducer(state.logState, action),
    statsState: statsReducer(state.statsState, action));
