import 'package:intl/intl.dart';
import 'package:lifterapp/features/workouts/domain/exercise.dart';

import './workout.dart';

class Session {
  int? _id;
  int? _trainingId;
  int? _number;
  List<Workout> workouts;
  DateTime timestamp;

  bool get isPersisted => _id != null && _trainingId != null;
  bool isStartedInPastHours(int hours) =>
      timestamp.difference(DateTime.now()).inHours > hours;
  int? get id => _id;

  bool get hasWorkouts => workouts.isNotEmpty;
  double get trainingVolume {
    return hasWorkouts
        ? workouts.map((e) => e.trainingVolume).reduce((a, b) => a + b)
        : 0.0;
  }

  get number => _number;
  get date => DateFormat("d.M.yyyy").format(timestamp);

  Session({required this.workouts, required this.timestamp});

  //Serialization
  Session.fromMap(Map<String, dynamic> res, this.workouts)
      : _id = res["id"],
        _trainingId = res["fk_training_id"],
        _number = res["number"] ?? 0,
        timestamp = DateTime.parse(res["timestamp"]);

  Map<String, dynamic> toMap({int? trainingId}) {
    return {
      'id': _id,
      'timestamp': timestamp.toString(),
      'fk_training_id': _trainingId ?? trainingId
    };
  }

  Workout? workoutFromSession(Exercise exercise) {
    var workout =
        workouts.where((workout) => workout.exercise.id == exercise.id);

    if (workout.isEmpty) {
      return null;
    }

    return workout.first;
  }
}
