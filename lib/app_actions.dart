import 'package:lifterapp/models/workout.dart'
    show Workout, WorkoutCard, WorkoutGroup;

class InsertWorkoutAction {
  final WorkoutGroup? latestWorkoutGroup;
  final List<WorkoutGroup> workoutGroups;
  final List<Workout> log;
  List<WorkoutCard> cards;

  get getLatestWorkoutGroup => latestWorkoutGroup;
  get getWorkoutGroups => workoutGroups;
  get getWorkoutNames => log.map((e) => e.name).toSet().toList();

  InsertWorkoutAction(
      this.latestWorkoutGroup, this.workoutGroups, this.log, this.cards);
}

class ImportWorkoutListAction {
  final WorkoutGroup? latestWorkoutGroup;
  final List<WorkoutGroup> workoutGroups;
  final List<Workout> log;
  List<WorkoutCard> cards;

  get getLatestWorkoutGroup => latestWorkoutGroup;
  get getWorkoutGroups => workoutGroups;
  get getWorkoutNames => log.map((e) => e.name).toSet().toList();

  ImportWorkoutListAction(
      this.latestWorkoutGroup, this.workoutGroups, this.log, this.cards);
}

class DeleteWorkoutAction {
  final WorkoutGroup? latestWorkoutGroup;
  final List<WorkoutGroup> workoutGroups;
  final List<Workout> log;
  List<WorkoutCard> cards;

  get getLatestWorkoutGroup => latestWorkoutGroup;
  get getWorkoutGroups => workoutGroups;
  get getWorkoutNames => log.map((e) => e.name).toSet().toList();

  DeleteWorkoutAction(
      this.latestWorkoutGroup, this.workoutGroups, this.log, this.cards);
}

class GetLatestWorkoutGroupAction {
  final WorkoutGroup? latestWorkoutGroup;

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

class GetWorkoutNamesAction {
  final List<String> names;

  GetWorkoutNamesAction(this.names);
}
