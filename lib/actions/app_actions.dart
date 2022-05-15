import 'package:lifterapp/middleware/app_middleware.dart';
import 'package:lifterapp/models/month_workout_volume_statistics.dart';
import 'package:lifterapp/models/ordinal_workout_volumes.dart';
import 'package:lifterapp/models/workout.dart';
import 'package:lifterapp/models/workout_card.dart';
import 'package:lifterapp/models/workout_group.dart';

class BaseUpdateAction {
  final WorkoutGroup? latestWorkoutGroup;
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
      {required this.latestWorkoutGroup,
      required this.workoutGroups,
      required this.log,
      required this.cards,
      required this.ordinalWorkoutVolumes,
      required this.workoutVolumeStatistics,
      required this.yearWorkoutActivity});
}

class InsertWorkoutAction extends BaseUpdateAction {
  final Duration restingTime;

  InsertWorkoutAction(
      {latestWorkoutGroup,
      workoutGroups,
      log,
      cards,
      ordinalWorkoutVolumes,
      workoutVolumeStatistics,
      yearWorkoutActivity,
      required this.restingTime})
      : super(
          latestWorkoutGroup: latestWorkoutGroup,
          workoutGroups: workoutGroups,
          log: log,
          cards: cards,
          ordinalWorkoutVolumes: ordinalWorkoutVolumes,
          workoutVolumeStatistics: workoutVolumeStatistics,
          yearWorkoutActivity: yearWorkoutActivity,
        );
}

class ImportWorkoutListAction extends BaseUpdateAction {
  ImportWorkoutListAction(
      {latestWorkoutGroup,
      workoutGroups,
      log,
      cards,
      ordinalWorkoutVolumes,
      workoutVolumeStatistics,
      yearWorkoutActivity})
      : super(
          latestWorkoutGroup: latestWorkoutGroup,
          workoutGroups: workoutGroups,
          log: log,
          cards: cards,
          ordinalWorkoutVolumes: ordinalWorkoutVolumes,
          workoutVolumeStatistics: workoutVolumeStatistics,
          yearWorkoutActivity: yearWorkoutActivity,
        );
}

class DeleteWorkoutAction extends BaseUpdateAction {
  DeleteWorkoutAction(
      {latestWorkoutGroup,
      workoutGroups,
      log,
      cards,
      ordinalWorkoutVolumes,
      workoutVolumeStatistics,
      yearWorkoutActivity})
      : super(
          latestWorkoutGroup: latestWorkoutGroup,
          workoutGroups: workoutGroups,
          log: log,
          cards: cards,
          ordinalWorkoutVolumes: ordinalWorkoutVolumes,
          workoutVolumeStatistics: workoutVolumeStatistics,
          yearWorkoutActivity: yearWorkoutActivity,
        );
}

class GetLatestWorkoutGroupAction {
  final WorkoutGroup? latestWorkoutGroup;

  GetLatestWorkoutGroupAction(this.latestWorkoutGroup);
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
