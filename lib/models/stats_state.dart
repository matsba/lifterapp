import 'package:lifterapp/models/month_workout_volume_statistics.dart';
import 'package:lifterapp/models/ordinal_workout_volumes.dart';
import 'package:flutter/material.dart';

@immutable
class StatsState {
  final List<String> workoutNamesWithoutBodyWeigth;
  final List<OridnalWorkoutVolumes> ordinalWorkoutVolumes;
  final MonthWorkoutVolumeStatistics workoutVolumeStatistics;
  final List<int> yearWorkoutActivity;

  StatsState(
      {required this.workoutNamesWithoutBodyWeigth,
      required this.ordinalWorkoutVolumes,
      required this.workoutVolumeStatistics,
      required this.yearWorkoutActivity});

  StatsState.initial()
      : workoutNamesWithoutBodyWeigth = [],
        ordinalWorkoutVolumes = [],
        workoutVolumeStatistics =
            MonthWorkoutVolumeStatistics(acuteLoad: null, chronicLoad: null),
        yearWorkoutActivity = List.filled(52, 0);

  copyWith(
          {List<String>? workoutNamesWithoutBodyWeigth,
          List<OridnalWorkoutVolumes>? ordinalWorkoutVolumes,
          MonthWorkoutVolumeStatistics? workoutVolumeStatistics,
          List<int>? yearWorkoutActivity}) =>
      StatsState(
          workoutNamesWithoutBodyWeigth: workoutNamesWithoutBodyWeigth ??
              this.workoutNamesWithoutBodyWeigth,
          ordinalWorkoutVolumes:
              ordinalWorkoutVolumes ?? this.ordinalWorkoutVolumes,
          workoutVolumeStatistics:
              workoutVolumeStatistics ?? this.workoutVolumeStatistics,
          yearWorkoutActivity: yearWorkoutActivity ?? this.yearWorkoutActivity);
}
