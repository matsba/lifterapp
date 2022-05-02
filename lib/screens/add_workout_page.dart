import 'package:flutter/material.dart'
    show
        Axis,
        BuildContext,
        Center,
        Colors,
        Column,
        Container,
        EdgeInsets,
        ElevatedButton,
        GridView,
        Key,
        MediaQuery,
        OutlinedButton,
        Padding,
        Scaffold,
        SizedBox,
        Slider,
        SliverGridDelegateWithFixedCrossAxisCount,
        StatelessWidget,
        Text,
        TextButton,
        TextField,
        TextStyle,
        Theme,
        Widget;
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart' show StoreConnector;
import 'package:lifterapp/app_actions.dart' show UpdateWorkoutFormInputAction;
import 'package:lifterapp/app_middleware.dart' show insertWorkout;
import 'package:lifterapp/app_state.dart' show AppState;
import 'package:lifterapp/components/app_scaffold.dart';
import 'package:lifterapp/components/bottom_navigationbar.dart'
    show BottomNavBar;
import 'package:lifterapp/components/title_row.dart';
import 'package:lifterapp/models/workout.dart'
    show WorkoutFormInput, WorkoutGroup;

class AddWorkoutPage extends StatelessWidget {
  const AddWorkoutPage({Key? key}) : super(key: key);

  Widget _inputWorkoutName() {
    return StoreConnector<AppState, _TextAutocompleteViewModel<String>>(
        converter: (store) => _TextAutocompleteViewModel(
            store.state.workoutNames,
            store.state.workoutFormInput.name,
            (value) =>
                store.dispatch(UpdateWorkoutFormInputAction({"name": value}))),
        builder: (context, vm) {
          return Column(
            children: [
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }
                  return vm.names.where((String option) {
                    return option.contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: vm.updateValue,
                initialValue: TextEditingValue(text: vm.value),
                fieldViewBuilder: (BuildContext context,
                    TextEditingController fieldTextEditingController,
                    FocusNode fieldFocusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextField(
                    controller: fieldTextEditingController,
                    focusNode: fieldFocusNode,
                    onChanged: vm.updateValue,
                  );
                },
              )
            ],
          );
        });
  }

  Widget _inputGridButtonNumberInput(int countOfInputs, BuildContext context) {
    var size = MediaQuery.of(context).size;

    bgColor(stateValue, inputValue) {
      if (stateValue == inputValue) {
        return Theme.of(context).colorScheme.primary;
      }
      if (stateValue > inputValue) {
        return Theme.of(context).colorScheme.primary.withOpacity(0.5);
      }
      return Colors.grey.shade300;
    }

    final double itemHeight = size.height / 4;
    final double itemWidth = size.width;

    return StoreConnector<AppState, _FormInputViewModel<int>>(
        converter: (store) => _FormInputViewModel(
            store.state.workoutFormInput.reps,
            (value) =>
                store.dispatch(UpdateWorkoutFormInputAction({"reps": value}))),
        builder: (context, vm) {
          return Column(children: [
            GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: (itemWidth / itemHeight)),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: countOfInputs,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final inputValue = index + 1;
                  return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: OutlinedButton(
                          child: Center(child: Text('${inputValue}')),
                          onPressed: () => vm.updateValue(inputValue),
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: bgColor(vm.value!, inputValue),
                          )));
                }),
          ]);
        });
  }

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

  Widget _sliderInput(Widget title) {
    double roundToClosestHalf(value) => ((value * 2).roundToDouble() / 2);
    const double minValue = 0;
    const double maxValue = 200;
    final int divisionToTwoAndHalf = (maxValue * 0.4).round();

    return StoreConnector<AppState, _WeigthViewModel<double>>(
        converter: (store) => _WeigthViewModel(
            store.state.workoutFormInput.weigth,
            store.state.workoutFormInput.bodyWeigth,
            (value) =>
                store.dispatch(UpdateWorkoutFormInputAction({"weigth": value})),
            (value) => store
                .dispatch(UpdateWorkoutFormInputAction({"bodyWeigth": value}))),
        builder: (context, vm) {
          bool showSlider = !vm.switchValue;
          return Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                title,
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
                  vm.value, vm.updateValue, minValue, maxValue),
            if (showSlider)
              Slider(
                  value: vm.value ?? 0,
                  min: minValue,
                  max: maxValue,
                  divisions: divisionToTwoAndHalf,
                  label: "${roundToClosestHalf(vm.value).toString()} kg",
                  onChanged: (double value) {
                    final double roundedValue = roundToClosestHalf(value);
                    vm.updateValue(roundedValue);
                  }),
          ]);
        });
  }

  Widget _submitButton(void Function() onSuccessCallback) {
    return StoreConnector<AppState, _FormInputViewModel<WorkoutFormInput>>(
        converter: (store) => _FormInputViewModel(store.state.workoutFormInput,
            (form) => store.dispatch(insertWorkout(form!))),
        builder: (context, vm) {
          return Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: ElevatedButton(
              onPressed: () {
                vm.updateValue(vm.value);
                onSuccessCallback();
              },
              child: const SizedBox(
                  child: Center(child: Text('Lisää')), height: 50.0),
            ),
          );
        });
  }

  void _showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 110),
          child: Column(
            children: [
              TitleRow("Lisätty settiin!"),
              _latestWorkoutSection(),
            ],
          ),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _latestWorkoutSection() {
    return StoreConnector<AppState, WorkoutGroup?>(
        converter: (store) => store.state.latestWorkout,
        builder: (context, workout) {
          if (workout != null) {
            return Card(
              child: ListTile(
                leading: Icon(
                  Icons.star_rate_rounded,
                  size: 30,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text("${workout.name}: ${workout.setFormat}"),
                subtitle: Text(workout.dateFormat),
                dense: true,
                style: ListTileStyle.drawer,
              ),
            );
          } else {
            return const Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Ei viimeistä treeniä"),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TitleRow("Lisää treeni", isHeading: true),
            TitleRow("Harjoitus"),
            _inputWorkoutName(),
            TitleRow("Toistot"),
            _inputGridButtonNumberInput(20, context),
            _sliderInput(
              TitleRow("Paino"),
            ),
            _submitButton(() => _showSnackBar(context)),
            TitleRow("Viimeisin setti"),
            _latestWorkoutSection()
          ],
        ),
      ),
    );
  }
}

class _TextAutocompleteViewModel<T> extends _FormInputViewModel {
  final List<String> names;

  _TextAutocompleteViewModel(this.names, value, updateValue)
      : super(value, updateValue);
}

class _WeigthViewModel<T> extends _FormInputViewModel {
  final bool switchValue;
  final void Function(bool?) updateSwitchValue;

  _WeigthViewModel(value, this.switchValue, updateValue, this.updateSwitchValue)
      : super(value, updateValue);
}

class _FormInputViewModel<T> {
  final T? value;
  final void Function(T?) updateValue;

  _FormInputViewModel(this.value, this.updateValue);
}
