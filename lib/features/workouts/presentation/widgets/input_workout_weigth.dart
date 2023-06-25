import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifterapp/common_widgets/title_row.dart';
import 'package:lifterapp/contants.dart';
import 'package:lifterapp/features/workouts/presentation/add_workout_page_controller.dart';

class InputWorkoutWeigth extends ConsumerWidget {
  int _divisionToTwoAndHalf(double value) => (value * 0.4).round();
  double _roundToClosestHalf(value) => ((value * 2).roundToDouble() / 2);

  Widget _weigthManualInputField(double sliderValue,
      void Function(double) updateValue, double minValue, double maxValue) {
    TextEditingController fieldTextEditingController =
        TextEditingController(text: sliderValue.toString());

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: maxValue.toString().length * 10.0,
          child: TextField(
            textAlign: TextAlign.center,
            controller: fieldTextEditingController,
            keyboardType: TextInputType.number,
            onSubmitted: (value) {
              double? converted = double.tryParse(value);

              //check that value is double
              if (converted == null) {
                return updateValue(0.0);
              }

              //Check for slider min and max values and default to them if submitted value is bigger
              if (converted >= minValue && converted <= maxValue) {
                return updateValue(converted);
              }

              if (converted < minValue) {
                return updateValue(minValue);
              }

              if (converted > maxValue) {
                return updateValue(maxValue);
              }
            },
          ),
        ),
        Text("kg")
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var weigth = ref
        .watch(addWorkoutFormProvider.select((value) => value.workoutWeigth));
    var bodyWeigth = ref.watch(
        addWorkoutFormProvider.select((value) => value.exerciseIsBodyWeigth));
    var showSlider = !bodyWeigth;

    void updateWeigth(double weigth) =>
        ref.read(addWorkoutFormProvider.notifier).setWeigth(weigth);
    void updateBodyWeigth(bool bodyWeigth) =>
        ref.read(addWorkoutFormProvider.notifier).setIsBodyWeigth(bodyWeigth);

    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TitleRow("Paino"),
          Row(
            children: [
              Text("Kehonpaino"),
              Switch(value: bodyWeigth, onChanged: updateBodyWeigth),
            ],
          ),
        ],
      ),
      if (showSlider)
        _weigthManualInputField(weigth, updateWeigth, WEIGTH_SLIDER_MIN_VALUE,
            WEIGTH_SLIDER_MAX_VALUE),
      if (showSlider)
        Slider(
            value: weigth ?? 0,
            min: WEIGTH_SLIDER_MIN_VALUE,
            max: WEIGTH_SLIDER_MAX_VALUE,
            divisions: _divisionToTwoAndHalf(WEIGTH_SLIDER_MAX_VALUE),
            label: "${_roundToClosestHalf(weigth).toString()} kg",
            onChanged: (double value) {
              final double roundedValue = _roundToClosestHalf(value);
              updateWeigth(roundedValue);
            }),
    ]);
  }
}
