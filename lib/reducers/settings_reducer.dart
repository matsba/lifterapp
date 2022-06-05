import 'package:lifterapp/actions/app_actions.dart';
import 'package:lifterapp/models/settings_state.dart';
import 'package:redux/redux.dart';

Reducer<SettingsState> settingsReducer = combineReducers([
  TypedReducer(_updateUsingRestingTime),
  TypedReducer(_updateRestingTimeSeconds),
  TypedReducer(_getRestingTimeSettings),
]);

SettingsState _updateUsingRestingTime(
        SettingsState state, UpdateUsingRestingTimeAction action) =>
    state.copyWith(usingRestingTime: action.usingRestingTime);

SettingsState _updateRestingTimeSeconds(
        SettingsState state, UpdateRestingTimeInSecondsAction action) =>
    state.copyWith(restingTimeInSeconds: action.seconds);

SettingsState _getRestingTimeSettings(
        SettingsState state, GetSettingsAction action) =>
    state.copyWith(
        restingTimeInSeconds: action.restingTimeInSeconds,
        usingRestingTime: action.usingRestingTime);
