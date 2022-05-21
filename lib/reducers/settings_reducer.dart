import 'package:lifterapp/actions/app_actions.dart';
import 'package:lifterapp/models/settings_state.dart';
import 'package:redux/redux.dart';

Reducer<SettingsState> settingsReducer = combineReducers([
  TypedReducer(_updateUsingRestingTime),
  TypedReducer(_updateRestingTimeSeconds),
]);

SettingsState _updateUsingRestingTime(
        SettingsState state, UpdateUsingRestingTimeAction action) =>
    state.copyWith(usingRestingTime: action.usingRestingTime);

SettingsState _updateRestingTimeSeconds(
        SettingsState state, UpdateRestingTimeInSecondsAction action) =>
    state.copyWith(restingTimeInSeconds: action.seconds);
