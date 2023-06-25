class WorkoutSet {
  int? _id;
  int? _workoutId;
  int reps;
  DateTime timestamp;
  double weigth;

  bool get isPersisted => _id != null && _workoutId != null;
  int? get id => _id;
  int? get workoutId => _workoutId;

  WorkoutSet(
      {required this.reps, required this.weigth, required this.timestamp});

  //Serialization
  WorkoutSet.fromMap(Map<String, dynamic> res)
      : _id = res["id"],
        _workoutId = res["fk_workout_id"],
        reps = res["reps"],
        timestamp = DateTime.parse(res["timestamp"]),
        weigth = res["weigth"];

  Map<String, dynamic> toMap({int? workoutId}) {
    return {
      'id': _id,
      "reps": reps,
      "timestamp": timestamp.toString(),
      "weigth": weigth,
      "fk_workout_id": _workoutId ?? workoutId
    };
  }

  @override
  String toString() =>
      "id: $_id, workoutId: $_workoutId, reps: $reps, timestamp: ${timestamp.toString()}, weigth: $weigth";
}
