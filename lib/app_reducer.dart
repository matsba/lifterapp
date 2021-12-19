import 'package:lifterapp/app_actions.dart'
    show
        DeletetWorkoutAction,
        GetLatestWorkoutGroupAction,
        GetWorkoutCardsAction,
        GetWorkoutLogAction,
        InsertWorkoutAction,
        NavigateWithNavbarAction,
        UpdateWorkoutFormInputAction;
import 'package:lifterapp/app_state.dart' show AppState;

AppState reducer(AppState state, dynamic action) {
  if (action is GetLatestWorkoutGroupAction) {
    return AppState(
        latestWorkout: action.latestWorkoutGroup,
        workouts: state.workouts,
        workoutFormInput: state.workoutFormInput,
        workoutCards: state.workoutCards,
        rawWorkouts: state.rawWorkouts);
  }
  if (action is GetWorkoutLogAction) {
    return AppState(
        latestWorkout: state.latestWorkout,
        workouts: state.workouts,
        workoutFormInput: state.workoutFormInput,
        workoutCards: state.workoutCards,
        rawWorkouts: action.workouts);
  }
  if (action is GetWorkoutCardsAction) {
    return AppState(
        latestWorkout: state.latestWorkout,
        workouts: state.workouts,
        workoutFormInput: state.workoutFormInput,
        workoutCards: action.cards,
        rawWorkouts: state.rawWorkouts);
  }
  if (action is InsertWorkoutAction) {
    return AppState(
        latestWorkout: action.getLatestWorkoutGroup,
        workouts: action.getWorkoutGroups,
        workoutFormInput: state.workoutFormInput,
        workoutCards: action.cards,
        rawWorkouts: action.log);
  }
  if (action is DeletetWorkoutAction) {
    return AppState(
        latestWorkout: action.getLatestWorkoutGroup,
        workouts: action.getWorkoutGroups,
        workoutFormInput: state.workoutFormInput,
        workoutCards: action.cards,
        rawWorkouts: action.log);
  }
  if (action is UpdateWorkoutFormInputAction) {
    var form = state.workoutFormInput
        .newFromFormData(action.input, state.workoutFormInput);

    return AppState(
        latestWorkout: state.latestWorkout,
        workouts: state.workouts,
        workoutFormInput: form,
        workoutCards: state.workoutCards,
        rawWorkouts: state.rawWorkouts);
  }

  return state;
}
