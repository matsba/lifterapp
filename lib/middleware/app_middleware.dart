import 'package:lifterapp/actions/app_actions.dart';
import 'package:lifterapp/models/app_state.dart';
import 'package:lifterapp/models/workout_form_input.dart';
import 'package:lifterapp/services/notification_service.dart';
import 'package:lifterapp/services/settings_repository.dart';
import 'package:lifterapp/services/workout_repository.dart';
import 'package:lifterapp/models/workout.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

WorkoutRepository workoutRepository = WorkoutRepository();
SettingsReposity settingsReposity = SettingsReposity();

ThunkAction<AppState> insertWorkout(WorkoutFormInput workout) {
  return (Store<AppState> store) async {
    Workout insert = Workout(
        name: workout.name!,
        reps: workout.reps!,
        weigth: workout.weigth!,
        bodyWeigth: workout.bodyWeigth,
        timestamp: DateTime.now());

    await workoutRepository.insert(insert);

    bool restingTimeSettingOn =
        await settingsReposity.getRestingTimeSwitchSetting();

    Duration? restingTime;

    if (restingTimeSettingOn) {
      restingTime = Duration(
          seconds: await settingsReposity.getRestingTimeInSecondsSetting());

      await NotificationService()
          .scheduleNotification(seconds: restingTime.inSeconds);
    }

    store.dispatch(InsertWorkoutAction(
      latestWorkoutGroup: await workoutRepository.getLatestGroup(),
      workoutGroups: await workoutRepository.getAllGroups(),
      log: await workoutRepository.getAll(),
      cards: await workoutRepository.getAllCards(),
      ordinalWorkoutVolumes: await workoutRepository.getOridnalWorkoutVolumes(),
      workoutVolumeStatistics: await workoutRepository.getMonthWorkoutStats(),
      yearWorkoutActivity: await workoutRepository.getYearsWeeklyWorkouts(),
      restingTime: restingTime,
    ));
  };
}

ThunkAction<AppState> importWorkoutList(List<Workout> workoutsList) {
  return (Store<AppState> store) async {
    await workoutRepository.replaceAllWorkoutsWithList(workoutsList);
    store.dispatch(ImportWorkoutListAction(
        latestWorkoutGroup: await workoutRepository.getLatestGroup(),
        workoutGroups: await workoutRepository.getAllGroups(),
        log: await workoutRepository.getAll(),
        cards: await workoutRepository.getAllCards(),
        ordinalWorkoutVolumes:
            await workoutRepository.getOridnalWorkoutVolumes(),
        workoutVolumeStatistics: await workoutRepository.getMonthWorkoutStats(),
        yearWorkoutActivity: await workoutRepository.getYearsWeeklyWorkouts()));
  };
}

ThunkAction<AppState> getLatestWorkoutGroup() {
  return (Store<AppState> store) async {
    var latest = await workoutRepository.getLatestGroup();
    store.dispatch(GetLatestWorkoutGroupAction(latest));
  };
}

ThunkAction<AppState> getWorkoutCards() {
  return (Store<AppState> store) async {
    var cards = await workoutRepository.getAllCards();
    store.dispatch(GetWorkoutCardsAction(cards));
  };
}

ThunkAction<AppState> getWorkoutLog() {
  return (Store<AppState> store) async {
    var log = await workoutRepository.getAll();
    store.dispatch(GetWorkoutLogAction(log));
  };
}

ThunkAction<AppState> getOrdinalWorkoutVolumes(String? filter) {
  return (Store<AppState> store) async {
    var data = await workoutRepository.getOridnalWorkoutVolumes(filter: filter);
    store.dispatch(GetOrdinalWorkoutVolumesAction(data));
  };
}

ThunkAction<AppState> getWorkoutVolumeStatistics() {
  return (Store<AppState> store) async {
    var data = await workoutRepository.getMonthWorkoutStats();
    store.dispatch(GetMonthWorkoutVolumeStatisticsAction(data));
  };
}

ThunkAction<AppState> getYearWorkoutActivity() {
  return (Store<AppState> store) async {
    var data = await workoutRepository.getYearsWeeklyWorkouts();
    store.dispatch(GetYearWorkoutActivityAction(data));
  };
}

ThunkAction<AppState> deleteWorkout(int id) {
  return (Store<AppState> store) async {
    await workoutRepository.deleteWorkout(id);
    store.dispatch(DeleteWorkoutAction(
        latestWorkoutGroup: await workoutRepository.getLatestGroup(),
        workoutGroups: await workoutRepository.getAllGroups(),
        log: await workoutRepository.getAll(),
        cards: await workoutRepository.getAllCards(),
        ordinalWorkoutVolumes:
            await workoutRepository.getOridnalWorkoutVolumes(),
        workoutVolumeStatistics: await workoutRepository.getMonthWorkoutStats(),
        yearWorkoutActivity: await workoutRepository.getYearsWeeklyWorkouts()));
  };
}

ThunkAction<AppState> getSettings() {
  return (Store<AppState> store) async {
    store.dispatch(GetSettingsAction(
        restingTimeInSeconds:
            await settingsReposity.getRestingTimeInSecondsSetting(),
        usingRestingTime:
            await settingsReposity.getRestingTimeSwitchSetting()));
  };
}

ThunkAction<AppState> updateUsingRestingTimeSetting(bool switchValue) {
  return (Store<AppState> store) async {
    await settingsReposity.saveRestingTimeSwitchSetting(switchValue);
    store.dispatch(UpdateUsingRestingTimeAction(switchValue));
  };
}

ThunkAction<AppState> updateRestingTimeSeconds(int seconds) {
  return (Store<AppState> store) async {
    if (seconds < 600 || seconds >= 0) {
      await settingsReposity.saveRestingTimeInSecondsSetting(seconds);
      store.dispatch(UpdateRestingTimeInSecondsAction(seconds));
    }
  };
}

ThunkAction<AppState> cancelRestingTime() {
  return (Store<AppState> store) async {
    await NotificationService().cancelScheduledNotification();

    store.dispatch(ResetRestingTimeAction());
  };
}
