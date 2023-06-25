import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifterapp/common_widgets/title_row.dart';
import 'package:lifterapp/features/workouts/presentation/add_workout_page_controller.dart';

class InputWorkoutReps extends ConsumerWidget {
  final int countOfInputs;

  InputWorkoutReps({required this.countOfInputs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    var reps =
        ref.watch(addWorkoutFormProvider.select((value) => value.workoutReps));

    void updateReps(int reps) =>
        ref.read(addWorkoutFormProvider.notifier).setReps(reps);

    Color _bgColor(stateValue, inputValue) {
      if (stateValue == inputValue) {
        return Theme.of(context).colorScheme.primary;
      }
      if (stateValue > inputValue) {
        return Theme.of(context).colorScheme.primary.withOpacity(0.5);
      }
      return Colors.grey.shade300;
    }

    final double itemHeight = size.height / 4;
    final double itemWidth = size.width * 1.2;

    return Column(children: [
      TitleRow("Toistot"),
      GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, childAspectRatio: (itemWidth / itemHeight)),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: countOfInputs,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            final inputValue = index + 1;
            return Padding(
                padding: const EdgeInsets.all(2.0),
                child: OutlinedButton(
                    child: Center(child: Text('$inputValue')),
                    onPressed: () => updateReps(inputValue),
                    style: OutlinedButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: _bgColor(reps, inputValue),
                        side: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.2)),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))))));
          }),
    ]);
  }
}
