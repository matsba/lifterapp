import 'package:lifterapp/actions/app_actions.dart';
import 'package:lifterapp/models/list_state.dart';
import 'package:redux/redux.dart';

Reducer<ListState> listReducer = combineReducers([
  TypedReducer(_getWorkoutCards),
  TypedReducer(_getWorkoutCardsAfterUpdate),
  TypedReducer(_getWorkoutCardsAfterDelete),
  TypedReducer(_getWorkoutCardsAfterImport),
]);

ListState _getWorkoutCards(ListState state, GetWorkoutCardsAction action) =>
    state.copyWith(workoutCards: action.cards);

ListState _getWorkoutCardsAfterUpdate(
        ListState state, InsertWorkoutAction action) =>
    state.copyWith(workoutCards: action.cards);

ListState _getWorkoutCardsAfterDelete(
        ListState state, DeleteWorkoutAction action) =>
    state.copyWith(workoutCards: action.cards);

ListState _getWorkoutCardsAfterImport(
        ListState state, ImportWorkoutListAction action) =>
    state.copyWith(workoutCards: action.cards);
