import 'package:lifterapp/models/workout_card.dart';
import 'package:meta/meta.dart';

@immutable
class ListState {
  final List<WorkoutCard> workoutCards;

  ListState({required this.workoutCards});

  ListState.initial() : workoutCards = [];

  ListState copyWith({List<WorkoutCard>? workoutCards}) =>
      ListState(workoutCards: workoutCards ?? this.workoutCards);
}
