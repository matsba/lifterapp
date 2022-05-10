import 'package:lifterapp/models/workout_group.dart';
import 'package:lifterapp/models/workout_name_group.dart';

class WorkoutCard {
  final String date;
  final List<WorkoutGroup> workouts;

  String get duration {
    List<DateTime> timestamps =
        workouts.map((x) => x.timestampsInListFormat).expand((x) => x).toList();
    timestamps.sort((a, b) => a.compareTo(b));
    var difference = timestamps.last.difference(timestamps.first);
    return "${difference.inMinutes} mins";
  }

  double get overallVolume =>
      groupWorkoutsByName.map((e) => e.trainingVolume).reduce((a, b) => a + b);

  List<WorkoutNameGroup> get groupWorkoutsByName {
    List<WorkoutNameGroup> setsGrouped = [];
    List<WorkoutGroup> grouped = [];
    double volume = 0;

    void init() {
      volume = 0;
      grouped.clear();
    }

    for (var i = 0; i < workouts.length; i++) {
      var current = workouts[i];
      grouped.add(current);
      volume = grouped
          .map((workout) =>
              workout.sets *
              workout.reps *
              (workout.bodyWeigth ? 1 : workout.weigth))
          .reduce((a, b) => a + b)
          .toDouble();

      if (i + 1 >= workouts.length) {
        setsGrouped.add(WorkoutNameGroup(
            name: current.name,
            workouts: [...grouped],
            trainingVolume: volume));
        init();
        break;
      }

      var next = workouts[i + 1];

      if (current.name != next.name) {
        setsGrouped.add(WorkoutNameGroup(
            name: current.name,
            workouts: [...grouped],
            trainingVolume: volume));
        init();
      }
    }
    return setsGrouped;
  }

  WorkoutCard({required this.date, required this.workouts});
}
