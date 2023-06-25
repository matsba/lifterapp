import 'package:lifterapp/features/workouts/domain/exercise.dart';
import 'package:lifterapp/features/workouts/domain/workout_set.dart';

class Workout {
  int? _id;
  int? _sessionId;
  List<WorkoutSet> sets;
  Exercise exercise;

  bool get isPersisted => _id != null && _sessionId != null;
  bool get hasSets => sets.isNotEmpty;
  int? get sessionId => _sessionId;
  int? get id => _id;

  DateTime? get startTime => hasSets ? sets.first.timestamp : null;
  DateTime? get endTime => hasSets ? sets.last.timestamp : null;
  double get trainingVolume =>
      hasSets ? sets.map((e) => e.reps * e.weigth).reduce((a, b) => a + b) : 0;

  List<String> get formattedSets {
    if (sets.isEmpty) {
      return [];
    }
    List<String> allFormatted = [];
    String currentFormatted = "";
    String previousRepsAndWeigth = "";
    int currentNumberOfSets = 1;

    for (int i = 0; i < sets.length; i++) {
      var reps = sets[i].reps;
      var weigth = sets[i].weigth;
      var currentRepsAndWeigth = "$reps x $weigth";

      if (previousRepsAndWeigth != "" &&
          currentRepsAndWeigth != previousRepsAndWeigth) {
        allFormatted.add(currentFormatted);
        currentNumberOfSets = 1;
      }

      currentFormatted = "$currentNumberOfSets x $reps x $weigth kg";
      currentNumberOfSets++;

      previousRepsAndWeigth = "$reps x $weigth";
    }

    allFormatted.add(currentFormatted);

    return allFormatted;
  }

  Workout({required this.exercise, required this.sets}) {
    sets.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  //Serialization
  Workout.fromMap(Map<String, dynamic> res, this.sets, this.exercise)
      : _id = res["id"],
        _sessionId = res["fk_session_id"];

  Map<String, dynamic> toMap({int? sessionId}) {
    return {
      'id': _id,
      "fk_session_id": _sessionId ?? sessionId,
      "fk_exercise_id": exercise.id
    };
  }
}
