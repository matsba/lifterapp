import 'package:lifterapp/app_actions.dart'
    show
        GetLatestWorkoutGroupAction,
        GetWorkoutCardsAction,
        GetWorkoutLogAction,
        InsertWorkoutAction;
import 'package:lifterapp/app_state.dart' show AppState;
import 'package:lifterapp/data/workout_repository.dart' show WorkoutRepository;
import 'package:lifterapp/models/workout.dart' show Workout, WorkoutFormInput;
import 'package:redux/redux.dart' show Store;
import 'package:redux_thunk/redux_thunk.dart' show ThunkAction;

WorkoutRepository repository = WorkoutRepository();

ThunkAction<AppState> insertWorkout(WorkoutFormInput workout) {
  return (Store<AppState> store) async {
    Workout insert = Workout(
        name: workout.name!,
        reps: workout.reps!,
        weigth: workout.weigth!,
        timestamp: DateTime.now());

    await repository.insert(insert);
    var workouts = await repository.getAllGroups();
    var latest = await repository.getLatestGroup();
    var log = await repository.getAll();
    store.dispatch(InsertWorkoutAction(latest, workouts, log));
  };
}

ThunkAction<AppState> getLatestWorkoutGroup() {
  return (Store<AppState> store) async {
    var latest = await repository.getLatestGroup();
    store.dispatch(GetLatestWorkoutGroupAction(latest));
  };
}

ThunkAction<AppState> getWorkoutCards() {
  return (Store<AppState> store) async {
    var cards = await repository.getAllCards();
    store.dispatch(GetWorkoutCardsAction(cards));
  };
}

ThunkAction<AppState> getWorkoutLog() {
  return (Store<AppState> store) async {
    var log = await repository.getAll();
    store.dispatch(GetWorkoutLogAction(log));
  };
}
