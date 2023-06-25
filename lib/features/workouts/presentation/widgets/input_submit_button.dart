import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifterapp/common_widgets/info_snackbar.dart';
import 'package:lifterapp/features/workouts/presentation/add_workout_page_controller.dart';

class InputSubmitButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var form = ref.watch(addWorkoutFormProvider);
    final WorkoutSubmitState submitNotifier =
        ref.watch(workoutSubmitStateProvider);

    bool isButtonDisabled =
        !form.validate() || submitNotifier != WorkoutSubmitState.editing;

    Future<void> submit() async {
      if (form.validate() && submitNotifier == WorkoutSubmitState.editing) {
        try {
          await ref.read(workoutSubmitStateProvider.notifier).submit(form);

          InfoSnackbarBuilder(
                  title: "${form.exerciseName} lisätty!", icon: Icons.star)
              .show(context);
        } catch (e) {
          print(e);
        }
      }
    }

    return Container(
      height: 60,
      width: double.infinity,
      child: TextButton(
        onPressed: isButtonDisabled ? null : () async => await submit(),
        child: Text('Lisää'),
      ),
    );
  }
}
