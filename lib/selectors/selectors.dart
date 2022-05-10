import 'package:lifterapp/models/add_workout_state.dart';
import 'package:lifterapp/models/app_state.dart';
import 'package:lifterapp/models/list_state.dart';
import 'package:lifterapp/models/log_state.dart';
import 'package:lifterapp/models/month_workout_volume_statistics.dart';
import 'package:lifterapp/models/ordinal_workout_volumes.dart';
import 'package:lifterapp/models/stats_state.dart';

ListState listStateSelector(AppState state) => state.listState;

LogState logStateSelector(AppState state) => state.logState;

List<int> yearWorkoutActivitySelector(StatsState state) =>
    state.yearWorkoutActivity;

List<OridnalWorkoutVolumes> ordinalWorkoutVolumesSelector(StatsState state) =>
    state.ordinalWorkoutVolumes;

MonthWorkoutVolumeStatistics workoutVolumeStatisticsSelectior(
        StatsState state) =>
    state.workoutVolumeStatistics;

List<String> workoutNamesSelector(LogState state) =>
    state.rawWorkouts.map((x) => x.name).toSet().toList();

List<String> workoutNamesWithoutBodyweightAndAllSelector(LogState state) => [
      "Kaikki",
      ...state.rawWorkouts
          .where((e) => !e.bodyWeigth)
          .map((e) => e.name)
          .toSet()
          .toList()
    ];

String? workoutFormInputNameSelector(AddWorkoutState state) =>
    state.workoutFormInput.name;

int? workoutFormInputRepsSelector(AddWorkoutState state) =>
    state.workoutFormInput.reps;

double? workoutFormInputWeigthSelector(AddWorkoutState state) =>
    state.workoutFormInput.weigth;

bool workoutFormInputBodyWeigthSelector(AddWorkoutState state) =>
    state.workoutFormInput.bodyWeigth;
