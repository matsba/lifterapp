import 'package:lifterapp/actions/app_actions.dart';
import 'package:lifterapp/models/app_state.dart';
import 'package:lifterapp/models/workout_form_input.dart';
import 'package:lifterapp/services/workout_repository.dart';
import 'package:lifterapp/models/workout.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

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
    store.dispatch(InsertWorkoutAction(
        latestWorkoutGroup: await repository.getLatestGroup(),
        workoutGroups: await repository.getAllGroups(),
        log: await repository.getAll(),
        cards: await repository.getAllCards(),
        ordinalWorkoutVolumes: await repository.getOridnalWorkoutVolumes(),
        workoutVolumeStatistics: await repository.getMonthWorkoutStats(),
        yearWorkoutActivity: await repository.getYearsWeeklyWorkouts()));
  };
}

ThunkAction<AppState> importWorkoutList(List<Workout> workoutsList) {
  return (Store<AppState> store) async {
    await repository.replaceAllWorkoutsWithList(workoutsList);
    store.dispatch(ImportWorkoutListAction(
        latestWorkoutGroup: await repository.getLatestGroup(),
        workoutGroups: await repository.getAllGroups(),
        log: await repository.getAll(),
        cards: await repository.getAllCards(),
        ordinalWorkoutVolumes: await repository.getOridnalWorkoutVolumes(),
        workoutVolumeStatistics: await repository.getMonthWorkoutStats(),
        yearWorkoutActivity: await repository.getYearsWeeklyWorkouts()));
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

ThunkAction<AppState> getOrdinalWorkoutVolumes(String? filter) {
  return (Store<AppState> store) async {
    var data = await repository.getOridnalWorkoutVolumes(filter: filter);
    store.dispatch(GetOrdinalWorkoutVolumesAction(data));
  };
}

ThunkAction<AppState> getWorkoutVolumeStatistics() {
  return (Store<AppState> store) async {
    var data = await repository.getMonthWorkoutStats();
    store.dispatch(GetMonthWorkoutVolumeStatisticsAction(data));
  };
}

ThunkAction<AppState> getYearWorkoutActivity() {
  return (Store<AppState> store) async {
    var data = await repository.getYearsWeeklyWorkouts();
    store.dispatch(GetYearWorkoutActivityAction(data));
  };
}

ThunkAction<AppState> deleteWorkout(int id) {
  return (Store<AppState> store) async {
    await repository.deleteWorkout(id);
    store.dispatch(DeleteWorkoutAction(
        latestWorkoutGroup: await repository.getLatestGroup(),
        workoutGroups: await repository.getAllGroups(),
        log: await repository.getAll(),
        cards: await repository.getAllCards(),
        ordinalWorkoutVolumes: await repository.getOridnalWorkoutVolumes(),
        workoutVolumeStatistics: await repository.getMonthWorkoutStats(),
        yearWorkoutActivity: await repository.getYearsWeeklyWorkouts()));
  };
}
