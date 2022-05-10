import 'package:lifterapp/actions/app_actions.dart';
import 'package:lifterapp/models/log_state.dart';
import 'package:redux/redux.dart';

Reducer<LogState> logReducer = combineReducers([
  TypedReducer(_getLog),
  TypedReducer(_updateLogAfterDelete),
  TypedReducer(_updateLogAfterInsert),
  TypedReducer(_updateLogAfterImport),
]);

LogState _getLog(LogState state, GetWorkoutLogAction action) =>
    state.copyWith(rawWorkouts: action.log);

LogState _updateLogAfterDelete(LogState state, DeleteWorkoutAction action) =>
    state.copyWith(rawWorkouts: action.log);

LogState _updateLogAfterInsert(LogState state, InsertWorkoutAction action) =>
    state.copyWith(rawWorkouts: action.log);

LogState _updateLogAfterImport(
        LogState state, ImportWorkoutListAction action) =>
    state.copyWith(rawWorkouts: action.log);
