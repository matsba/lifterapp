import 'package:flutter_test/flutter_test.dart';
import 'package:lifterapp/features/workouts/domain/add_workout_form.dart';

void main() {
  testWidgets('Add workout form with name, reps and weigth is valid',
      (tester) async {
    final form = AddWorkoutForm(
        exerciseIsBodyWeigth: false,
        exerciseName: "Kyykky",
        workoutReps: 10,
        workoutWeigth: 50.0);

    final result = form.validate();

    expect(true, result);
  });

  testWidgets('Add workout form isnt valid after initializing', (tester) async {
    final form = AddWorkoutForm.init();

    final result = form.validate();

    expect(false, result);
  });

  testWidgets('Add workout form isnt valid with empty name', (tester) async {
    final form = AddWorkoutForm(
        exerciseIsBodyWeigth: false,
        exerciseName: "",
        workoutReps: 10,
        workoutWeigth: 5.0);

    final result = form.validate();

    expect(false, result);
  });

  testWidgets('Add workout form isnt valid with zero reps', (tester) async {
    final form = AddWorkoutForm(
        exerciseIsBodyWeigth: false,
        exerciseName: "Kyykky",
        workoutReps: 0,
        workoutWeigth: 50.0);

    final result = form.validate();

    expect(false, result);
  });

  testWidgets('Add workout form isnt valid with weigth under 0.5 kgs',
      (tester) async {
    final form = AddWorkoutForm(
        exerciseIsBodyWeigth: false,
        exerciseName: "Kyykky",
        workoutReps: 10,
        workoutWeigth: 0.391);

    final result = form.validate();

    expect(false, result);
  });
}
