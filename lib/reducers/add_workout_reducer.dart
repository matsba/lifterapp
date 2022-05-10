import 'package:lifterapp/actions/app_actions.dart';
import 'package:lifterapp/models/add_workout_state.dart';
import 'package:redux/redux.dart';

Reducer<AddWorkoutState> addWorkoutReducer = combineReducers([
  TypedReducer(_insertWorkout),
  TypedReducer(_updateForm),
  TypedReducer(_updateLatestWorkoutAfterDelete),
]);

AddWorkoutState _insertWorkout(
        AddWorkoutState state, InsertWorkoutAction action) =>
    state.copyWith(
        workoutFormInput: state.workoutFormInput,
        latestWorkout: action.latestWorkoutGroup);

AddWorkoutState _updateForm(
        AddWorkoutState state, UpdateWorkoutFormInputAction action) =>
    state.copyWith(
        workoutFormInput: state.workoutFormInput
            .newFromFormData(action.input, state.workoutFormInput),
        latestWorkout: state.latestWorkout);

AddWorkoutState _updateLatestWorkoutAfterDelete(
        AddWorkoutState state, DeleteWorkoutAction action) =>
    state.copyWith(latestWorkout: action.latestWorkoutGroup);


  // if (action is InsertWorkoutAction) {
  //   return AppState(
  //       latestWorkout: action.getLatestWorkoutGroup,
  //       workouts: action.getWorkoutGroups,
  //       workoutFormInput: state.workoutFormInput,
  //       workoutCards: action.cards,
  //       rawWorkouts: action.log,
  //       workoutNames: action.getWorkoutNames,
  //       workoutNamesWithoutBodyWeigth: state.workoutNamesWithoutBodyWeigth,
  //       ordinalWorkoutVolumes: state.ordinalWorkoutVolumes,
  //       workoutVolumeStatistics: state.workoutVolumeStatistics,
  //       yearWorkoutActivity: state.yearWorkoutActivity);
  // }


/*     if (action is UpdateWorkoutFormInputAction) {
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
 */

// NOT NEEDED???
/*     if (action is GetLatestWorkoutGroupAction) {
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
  } */