import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:lifterapp/actions/app_actions.dart';
import 'package:lifterapp/components/title_row.dart';
import 'package:lifterapp/models/app_state.dart';
import 'package:lifterapp/models/form_input_view_model.dart';
import 'package:lifterapp/selectors/selectors.dart';
import 'package:redux/redux.dart';

class InputWorkoutWeigth extends StatelessWidget {
  final double _minValue = 0;
  final double _maxValue = 200;

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
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromStore(store),
        builder: (context, vm) {
          bool showSlider = !vm.switchValue;
          return Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TitleRow("Paino"),
                Row(
                  children: [
                    Text("Kehonpaino"),
                    Switch(
                        value: vm.switchValue, onChanged: vm.updateSwitchValue),
                  ],
                ),
              ],
            ),
            if (showSlider)
              _weigthManualInputField(
                  vm.value, vm.updateValue, _minValue, _maxValue),
            if (showSlider)
              Slider(
                  value: vm.value ?? 0,
                  min: _minValue,
                  max: _maxValue,
                  divisions: _divisionToTwoAndHalf(_maxValue),
                  label: "${_roundToClosestHalf(vm.value).toString()} kg",
                  onChanged: (double value) {
                    final double roundedValue = _roundToClosestHalf(value);
                    vm.updateValue(roundedValue);
                  }),
          ]);
        });
  }
}

class _ViewModel extends FormInputViewModel {
  final bool switchValue;
  final void Function(bool?) updateSwitchValue;

  _ViewModel(
      {required this.switchValue,
      required this.updateSwitchValue,
      required value,
      required updateValue})
      : super(value: value, updateValue: updateValue);

  static fromStore(Store<AppState> store) => _ViewModel(
      switchValue:
          workoutFormInputBodyWeigthSelector(store.state.addWorkoutState),
      updateSwitchValue: (value) =>
          store.dispatch(UpdateWorkoutFormInputAction({"bodyWeigth": value})),
      value: workoutFormInputWeigthSelector(store.state.addWorkoutState),
      updateValue: (value) =>
          store.dispatch(UpdateWorkoutFormInputAction({"weigth": value})));
}
