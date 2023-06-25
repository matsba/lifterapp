class AddWorkoutForm {
  final String exerciseName;
  final bool exerciseIsBodyWeigth;
  final int workoutReps;
  final double workoutWeigth;

  bool validate() {
    if (exerciseName.isEmpty) {
      print("Form name is empty!");
      return false;
    }

    if (workoutReps < 1) {
      print("Reps missing!");
      return false;
    }

    if (!exerciseIsBodyWeigth && workoutWeigth < 0.5) {
      print("Non bodyweigth workout needs to have larger weigth");
      return false;
    }
    return true;
  }

  AddWorkoutForm.init()
      : exerciseName = "",
        exerciseIsBodyWeigth = false,
        workoutReps = 0,
        workoutWeigth = 0.0;

  AddWorkoutForm copyWith(
      {String? exerciseName,
      bool? exerciseIsBodyWeigth,
      int? workoutReps,
      double? workoutWeigth}) {
    return AddWorkoutForm(
        exerciseName: exerciseName ?? this.exerciseName,
        exerciseIsBodyWeigth: exerciseIsBodyWeigth ?? this.exerciseIsBodyWeigth,
        workoutReps: workoutReps ?? this.workoutReps,
        workoutWeigth: workoutWeigth ?? this.workoutWeigth);
  }

  AddWorkoutForm(
      {required this.exerciseName,
      required this.exerciseIsBodyWeigth,
      required this.workoutReps,
      required this.workoutWeigth});
}
