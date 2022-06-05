import 'package:lifterapp/models/month_workout_volume_statistics.dart';
import 'package:lifterapp/models/ordinal_workout_volumes.dart';
import 'package:lifterapp/models/workout.dart';
import 'package:lifterapp/models/workout_card.dart';
import 'package:lifterapp/models/workout_group.dart';

class BaseUpdateAction {
  final List<WorkoutGroup> workoutGroups;
  final List<Workout> log;
  final List<WorkoutCard> cards;
  final List<OridnalWorkoutVolumes> ordinalWorkoutVolumes;
  final MonthWorkoutVolumeStatistics workoutVolumeStatistics;
  final List<int> yearWorkoutActivity;

  get getWorkoutGroups => workoutGroups;
  get getWorkoutNames => log.map((e) => e.name).toSet().toList();
  get getWorkoutNamesWithouBodyWeigth =>
      log.where((e) => !e.bodyWeigth).map((e) => e.name).toSet().toList();

  BaseUpdateAction(
      {required this.workoutGroups,
      required this.log,
      required this.cards,
      required this.ordinalWorkoutVolumes,
      required this.workoutVolumeStatistics,
      required this.yearWorkoutActivity});
}

class InsertWorkoutAction extends BaseUpdateAction {
  final Duration? restingTime;

  InsertWorkoutAction(
      {required super.workoutGroups,
      required super.log,
      required super.cards,
      required super.ordinalWorkoutVolumes,
      required super.workoutVolumeStatistics,
      required super.yearWorkoutActivity,
      required this.restingTime});
}

class ResetRestingTimeAction {
  ResetRestingTimeAction();
}

class ImportWorkoutListAction extends BaseUpdateAction {
  ImportWorkoutListAction(
      {required super.workoutGroups,
      required super.log,
      required super.cards,
      required super.ordinalWorkoutVolumes,
      required super.workoutVolumeStatistics,
      required super.yearWorkoutActivity});
}

class DeleteWorkoutAction extends BaseUpdateAction {
  DeleteWorkoutAction(
      {required super.workoutGroups,
      required super.log,
      required super.cards,
      required super.ordinalWorkoutVolumes,
      required super.workoutVolumeStatistics,
      required super.yearWorkoutActivity});
}

class GetOrdinalWorkoutVolumesAction {
  final List<OridnalWorkoutVolumes> ordinalWorkoutVolumes;

  GetOrdinalWorkoutVolumesAction(this.ordinalWorkoutVolumes);
}

class GetMonthWorkoutVolumeStatisticsAction {
  MonthWorkoutVolumeStatistics workoutVolumeStatistics;

  GetMonthWorkoutVolumeStatisticsAction(this.workoutVolumeStatistics);
}

class UpdateWorkoutFormInputAction {
  final Map<String, dynamic> input;

  UpdateWorkoutFormInputAction(this.input);
}

class GetWorkoutCardsAction {
  final List<WorkoutCard> cards;

  GetWorkoutCardsAction(this.cards);
}

class GetWorkoutLogAction {
  final List<Workout> log;

  GetWorkoutLogAction(this.log);
}

class GetYearWorkoutActivityAction {
  final List<int> yearWorkoutActivity;

  GetYearWorkoutActivityAction(this.yearWorkoutActivity);
}

class UpdateUsingRestingTimeAction {
  final bool usingRestingTime;

  UpdateUsingRestingTimeAction(this.usingRestingTime);
}

class UpdateRestingTimeInSecondsAction {
  final int seconds;

  UpdateRestingTimeInSecondsAction(this.seconds);
}

class GetSettingsAction {
  final bool usingRestingTime;
  final int restingTimeInSeconds;

  GetSettingsAction(
      {required this.usingRestingTime, required this.restingTimeInSeconds});
}
