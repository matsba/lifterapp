import 'package:lifterapp/models/workout.dart'
    show Workout, WorkoutCard, WorkoutGroup;

class InsertWorkoutAction {
  final WorkoutGroup latestWorkoutGroup;
  final List<WorkoutGroup> workoutGroups;
  final List<Workout> log;

  get getLatestWorkoutGroup => latestWorkoutGroup;
  get getWorkoutGroups => workoutGroups;

  InsertWorkoutAction(this.latestWorkoutGroup, this.workoutGroups, this.log);
}

class GetLatestWorkoutGroupAction {
  final WorkoutGroup latestWorkoutGroup;

  GetLatestWorkoutGroupAction(this.latestWorkoutGroup);
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
  final List<Workout> workouts;

  GetWorkoutLogAction(this.workouts);
}
