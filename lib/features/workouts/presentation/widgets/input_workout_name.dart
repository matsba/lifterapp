import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifterapp/common_widgets/title_row.dart';
import 'package:lifterapp/features/workouts/presentation/add_workout_page_controller.dart';

class InputWorkoutName extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var name =
        ref.watch(addWorkoutFormProvider.select((value) => value.exerciseName));

    void updateExerciseName(String name) =>
        ref.read(addWorkoutFormProvider.notifier).setName(name);

    return Column(
      children: [
        TitleRow("Harjoitus"),
        Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              debugPrint(
                  "AutoComplete textEditingValue ${textEditingValue.text}");
              if (textEditingValue.text == '') {
                debugPrint("Empty autocomplete");
                return const Iterable<String>.empty();
              }
              return ref.watch(exerciseProvider).when(
                  data: (data) {
                    return data.where((String option) {
                      return option
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  error: (err, _) => [],
                  loading: () => []);
            },
            onSelected: updateExerciseName,
            initialValue: TextEditingValue(text: name),
            fieldViewBuilder: (BuildContext context,
                TextEditingController fieldTextEditingController,
                FocusNode fieldFocusNode,
                VoidCallback onFieldSubmitted) {
              return TextField(
                controller: fieldTextEditingController,
                focusNode: fieldFocusNode,
                onChanged: updateExerciseName,
              );
            })
      ],
    );
  }
}
