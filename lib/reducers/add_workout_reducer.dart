import 'package:lifterapp/actions/app_actions.dart';
import 'package:lifterapp/models/add_workout_state.dart';
import 'package:redux/redux.dart';

Reducer<AddWorkoutState> addWorkoutReducer = combineReducers([
  TypedReducer(_insertWorkout),
  TypedReducer(_updateForm),
  TypedReducer(_resetRestingTime),
]);

AddWorkoutState _insertWorkout(
        AddWorkoutState state, InsertWorkoutAction action) =>
    state.copyWith(
        workoutFormInput: state.workoutFormInput,
        restingTime: action.restingTime);

AddWorkoutState _updateForm(
        AddWorkoutState state, UpdateWorkoutFormInputAction action) =>
    state.copyWith(
        workoutFormInput: state.workoutFormInput
            .newFromFormData(action.input, state.workoutFormInput),
        latestWorkout: state.latestWorkout);

AddWorkoutState _resetRestingTime(
        AddWorkoutState state, ResetRestingTimeAction action) =>
    AddWorkoutState(
        restingTime: null,
        latestWorkout: state.latestWorkout,
        workoutFormInput: state.workoutFormInput);
