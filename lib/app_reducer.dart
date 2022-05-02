import 'package:lifterapp/app_actions.dart';
import 'package:lifterapp/app_state.dart' show AppState;

AppState reducer(AppState state, dynamic action) {
  if (action is GetLatestWorkoutGroupAction) {
    return AppState(
        latestWorkout: action.latestWorkoutGroup,
        workouts: state.workouts,
        workoutFormInput: state.workoutFormInput,
        workoutCards: state.workoutCards,
        rawWorkouts: state.rawWorkouts,
        workoutNames: state.workoutNames,
        workoutNamesWithoutBodyWeigth: state.workoutNamesWithoutBodyWeigth,
        ordinalWorkoutVolumes: state.ordinalWorkoutVolumes,
        workoutVolumeStatistics: state.workoutVolumeStatistics,
        yearWorkoutActivity: state.yearWorkoutActivity);
  }
  if (action is GetWorkoutNamesAction) {
    return AppState(
        latestWorkout: state.latestWorkout,
        workouts: state.workouts,
        workoutFormInput: state.workoutFormInput,
        workoutCards: state.workoutCards,
        rawWorkouts: state.rawWorkouts,
        workoutNames: action.names,
        workoutNamesWithoutBodyWeigth: state.workoutNamesWithoutBodyWeigth,
        ordinalWorkoutVolumes: state.ordinalWorkoutVolumes,
        workoutVolumeStatistics: state.workoutVolumeStatistics,
        yearWorkoutActivity: state.yearWorkoutActivity);
  }
  if (action is GetWorkoutNamesWithouBodyWeigthAction) {
    return AppState(
        latestWorkout: state.latestWorkout,
        workouts: state.workouts,
        workoutFormInput: state.workoutFormInput,
        workoutCards: state.workoutCards,
        rawWorkouts: state.rawWorkouts,
        workoutNames: state.workoutNames,
        workoutNamesWithoutBodyWeigth: action.names,
        ordinalWorkoutVolumes: state.ordinalWorkoutVolumes,
        workoutVolumeStatistics: state.workoutVolumeStatistics,
        yearWorkoutActivity: state.yearWorkoutActivity);
  }
  if (action is GetWorkoutLogAction) {
    return AppState(
        latestWorkout: state.latestWorkout,
        workouts: state.workouts,
        workoutFormInput: state.workoutFormInput,
        workoutCards: state.workoutCards,
        rawWorkouts: action.workouts,
        workoutNames: state.workoutNames,
        workoutNamesWithoutBodyWeigth: state.workoutNamesWithoutBodyWeigth,
        ordinalWorkoutVolumes: state.ordinalWorkoutVolumes,
        workoutVolumeStatistics: state.workoutVolumeStatistics,
        yearWorkoutActivity: state.yearWorkoutActivity);
  }
  if (action is GetWorkoutCardsAction) {
    return AppState(
        latestWorkout: state.latestWorkout,
        workouts: state.workouts,
        workoutFormInput: state.workoutFormInput,
        workoutCards: action.cards,
        rawWorkouts: state.rawWorkouts,
        workoutNames: state.workoutNames,
        workoutNamesWithoutBodyWeigth: state.workoutNamesWithoutBodyWeigth,
        ordinalWorkoutVolumes: state.ordinalWorkoutVolumes,
        workoutVolumeStatistics: state.workoutVolumeStatistics,
        yearWorkoutActivity: state.yearWorkoutActivity);
  }
  if (action is GetOrdinalWorkoutVolumesAction) {
    return AppState(
        latestWorkout: state.latestWorkout,
        workouts: state.workouts,
        workoutFormInput: state.workoutFormInput,
        workoutCards: state.workoutCards,
        rawWorkouts: state.rawWorkouts,
        workoutNames: state.workoutNames,
        workoutNamesWithoutBodyWeigth: state.workoutNamesWithoutBodyWeigth,
        ordinalWorkoutVolumes: action.ordinalWorkoutVolumes,
        workoutVolumeStatistics: state.workoutVolumeStatistics,
        yearWorkoutActivity: state.yearWorkoutActivity);
  }
  if (action is GetMonthWorkoutVolumeStatisticsAction) {
    return AppState(
        latestWorkout: state.latestWorkout,
        workouts: state.workouts,
        workoutFormInput: state.workoutFormInput,
        workoutCards: state.workoutCards,
        rawWorkouts: state.rawWorkouts,
        workoutNames: state.workoutNames,
        workoutNamesWithoutBodyWeigth: state.workoutNamesWithoutBodyWeigth,
        ordinalWorkoutVolumes: state.ordinalWorkoutVolumes,
        workoutVolumeStatistics: action.workoutVolumeStatistics,
        yearWorkoutActivity: state.yearWorkoutActivity);
  }
  if (action is InsertWorkoutAction) {
    return AppState(
        latestWorkout: action.getLatestWorkoutGroup,
        workouts: action.getWorkoutGroups,
        workoutFormInput: state.workoutFormInput,
        workoutCards: action.cards,
        rawWorkouts: action.log,
        workoutNames: action.getWorkoutNames,
        workoutNamesWithoutBodyWeigth: state.workoutNamesWithoutBodyWeigth,
        ordinalWorkoutVolumes: state.ordinalWorkoutVolumes,
        workoutVolumeStatistics: state.workoutVolumeStatistics,
        yearWorkoutActivity: state.yearWorkoutActivity);
  }
  if (action is DeleteWorkoutAction) {
    return AppState(
        latestWorkout: action.getLatestWorkoutGroup,
        workouts: action.getWorkoutGroups,
        workoutFormInput: state.workoutFormInput,
        workoutCards: action.cards,
        rawWorkouts: action.log,
        workoutNames: action.getWorkoutNames,
        workoutNamesWithoutBodyWeigth: state.workoutNamesWithoutBodyWeigth,
        ordinalWorkoutVolumes: state.ordinalWorkoutVolumes,
        workoutVolumeStatistics: state.workoutVolumeStatistics,
        yearWorkoutActivity: state.yearWorkoutActivity);
  }
  if (action is UpdateWorkoutFormInputAction) {
    var form = state.workoutFormInput
        .newFromFormData(action.input, state.workoutFormInput);

    return AppState(
        latestWorkout: state.latestWorkout,
        workouts: state.workouts,
        workoutFormInput: form,
        workoutCards: state.workoutCards,
        rawWorkouts: state.rawWorkouts,
        workoutNames: state.workoutNames,
        workoutNamesWithoutBodyWeigth: state.workoutNamesWithoutBodyWeigth,
        ordinalWorkoutVolumes: state.ordinalWorkoutVolumes,
        workoutVolumeStatistics: state.workoutVolumeStatistics,
        yearWorkoutActivity: state.yearWorkoutActivity);
  }
  if (action is ImportWorkoutListAction) {
    return AppState(
        latestWorkout: action.getLatestWorkoutGroup,
        workouts: action.getWorkoutGroups,
        workoutFormInput: state.workoutFormInput,
        workoutCards: action.cards,
        rawWorkouts: action.log,
        workoutNames: action.getWorkoutNames,
        workoutNamesWithoutBodyWeigth: state.workoutNamesWithoutBodyWeigth,
        ordinalWorkoutVolumes: state.ordinalWorkoutVolumes,
        workoutVolumeStatistics: state.workoutVolumeStatistics,
        yearWorkoutActivity: state.yearWorkoutActivity);
  }
  if (action is GetYearWorkoutActivityAction) {
    return AppState(
        latestWorkout: state.latestWorkout,
        workouts: state.workouts,
        workoutFormInput: state.workoutFormInput,
        workoutCards: state.workoutCards,
        rawWorkouts: state.rawWorkouts,
        workoutNames: state.workoutNames,
        workoutNamesWithoutBodyWeigth: state.workoutNamesWithoutBodyWeigth,
        ordinalWorkoutVolumes: state.ordinalWorkoutVolumes,
        workoutVolumeStatistics: state.workoutVolumeStatistics,
        yearWorkoutActivity: action.yearWorkoutActivity);
  }

  return state;
}
