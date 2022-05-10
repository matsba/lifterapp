import 'package:lifterapp/models/workout_group.dart';

class WorkoutNameGroup {
  final String name;
  final List<WorkoutGroup> workouts;
  final double trainingVolume;

  WorkoutNameGroup(
      {required this.name,
      required this.workouts,
      required this.trainingVolume});
}
