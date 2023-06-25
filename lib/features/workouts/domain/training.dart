import 'package:lifterapp/features/workouts/domain/session.dart';
import 'package:lifterapp/features/workouts/domain/workout.dart';

class Training {
  int? _id;
  List<Session> sessions;
  int goalNumberOfSessionsPerWeek;

  bool get isPersisted => _id != null;
  int? get id => _id;
  get weeklyStats => null;

  Workout? latestWorkoutByName(String name) {
    if (name.isEmpty) return null;

    try {
      return sessions
          .expand((element) => element.workouts) //flatten
          .toList()
          .firstWhere((element) => element.exercise.name == name);
    } on StateError catch (_) {
      //catch firstWhere error if not found
      return null;
    }
  }

  List<Workout> allWorkouts() => sessions.expand((e) => e.workouts).toList();

  Training({required this.sessions, this.goalNumberOfSessionsPerWeek = 3}) {
    sessions.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  //Serialization
  Training.fromMap(Map<String, dynamic> res, List<Session> this.sessions)
      : _id = res["id"],
        goalNumberOfSessionsPerWeek = 3;

  Map<String, dynamic> toMap() {
    return {'id': _id};
  }
}
