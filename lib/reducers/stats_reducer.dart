import 'package:lifterapp/actions/app_actions.dart';
import 'package:lifterapp/models/stats_state.dart';
import 'package:redux/redux.dart';

Reducer<StatsState> statsReducer = combineReducers([
  TypedReducer(_getOrdinalWorkoutVolumes),
  TypedReducer(_getMonthWorkoutVolumes),
  TypedReducer(_getYearWorkoutActivity),
  TypedReducer(_updateStatsAfterInsert),
  TypedReducer(_updateStatsAfterImport),
  TypedReducer(_updateStatsAfterDelete),
]);

StatsState _getOrdinalWorkoutVolumes(
        StatsState state, GetOrdinalWorkoutVolumesAction action) =>
    state.copyWith(ordinalWorkoutVolumes: action.ordinalWorkoutVolumes);

StatsState _getMonthWorkoutVolumes(
        StatsState state, GetMonthWorkoutVolumeStatisticsAction action) =>
    state.copyWith(workoutVolumeStatistics: action.workoutVolumeStatistics);

StatsState _getYearWorkoutActivity(
        StatsState state, GetYearWorkoutActivityAction action) =>
    state.copyWith(yearWorkoutActivity: action.yearWorkoutActivity);

StatsState _updateStatsAfterInsert(
        StatsState state, InsertWorkoutAction action) =>
    state.copyWith(
        ordinalWorkoutVolumes: action.ordinalWorkoutVolumes,
        workoutVolumeStatistics: action.workoutVolumeStatistics,
        yearWorkoutActivity: action.yearWorkoutActivity);

StatsState _updateStatsAfterImport(
        StatsState state, ImportWorkoutListAction action) =>
    state.copyWith(
        ordinalWorkoutVolumes: action.ordinalWorkoutVolumes,
        workoutVolumeStatistics: action.workoutVolumeStatistics,
        yearWorkoutActivity: action.yearWorkoutActivity);

StatsState _updateStatsAfterDelete(
        StatsState state, DeleteWorkoutAction action) =>
    state.copyWith(
        ordinalWorkoutVolumes: action.ordinalWorkoutVolumes,
        workoutVolumeStatistics: action.workoutVolumeStatistics,
        yearWorkoutActivity: action.yearWorkoutActivity);
