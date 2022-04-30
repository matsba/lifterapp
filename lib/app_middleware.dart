import 'package:lifterapp/app_actions.dart'
    show
        DeleteWorkoutAction,
        GetLatestWorkoutGroupAction,
        GetWorkoutCardsAction,
        GetWorkoutLogAction,
        GetWorkoutNamesAction,
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
        bodyWeigth: workout.bodyWeigth,
        timestamp: DateTime.now());

    await repository.insert(insert);
    var workouts = await repository.getAllGroups();
    var latest = await repository.getLatestGroup();
    var cards = await repository.getAllCards();
    var log = await repository.getAll();
    store.dispatch(InsertWorkoutAction(latest, workouts, log, cards));
  };
}

ThunkAction<AppState> importWorkoutList(List<Workout> workoutsList) {
  return (Store<AppState> store) async {
    print("Replacing workouts with new ${workoutsList.length} workouts.");
    await repository.replaceAllWorkoutsWithList(workoutsList);
    print("Done. Getting updated data");
    var workouts = await repository.getAllGroups();
    var latest = await repository.getLatestGroup();
    var cards = await repository.getAllCards();
    var log = await repository.getAll();
    store.dispatch(InsertWorkoutAction(latest, workouts, log, cards));
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

ThunkAction<AppState> getWorkoutNames() {
  return (Store<AppState> store) async {
    var names = await repository.getWorkoutNames();
    store.dispatch(GetWorkoutNamesAction(names));
  };
}

ThunkAction<AppState> deleteWorkout(int id) {
  return (Store<AppState> store) async {
    await repository.deleteWorkout(id);

    var workouts = await repository.getAllGroups();
    var latest = await repository.getLatestGroup();
    var cards = await repository.getAllCards();
    var log = await repository.getAll();
    store.dispatch(DeleteWorkoutAction(latest, workouts, log, cards));
  };
}
