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
import 'package:lifterapp/models/workout.dart'
    show WorkoutFormInput, WorkoutGroup;

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget _inputWorkoutName() {
    return StoreConnector<AppState, _FormInputViewModel<String>>(
        converter: (store) => _FormInputViewModel(
            store.state.workoutFormInput.name,
            (value) =>
                store.dispatch(UpdateWorkoutFormInputAction({"name": value}))),
        builder: (context, vm) {
          return Column(
            children: [
              TextField(onChanged: vm.updateValue),
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

  Widget _sliderInput() {
    double roundToClosestHalf(value) => ((value * 2).roundToDouble() / 2);
    const double minValue = 0;
    const double maxValue = 100;
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
              children: [
                Text("Kehonpaino"),
                Switch(value: vm.switchValue, onChanged: vm.updateSwitchValue),
              ],
            ),
            if (showSlider) Text("${vm.value} kg"),
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

  Widget _submitButton() {
    return StoreConnector<AppState, _FormInputViewModel<WorkoutFormInput>>(
        converter: (store) => _FormInputViewModel(store.state.workoutFormInput,
            (form) => store.dispatch(insertWorkout(form!))),
        builder: (context, vm) {
          return Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: ElevatedButton(
              onPressed: () => vm.updateValue(vm.value),
              child: const SizedBox(
                  child: Center(child: Text('Lisää')), height: 50.0),
            ),
          );
        });
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
            return Text("Ei viimeistä treeniä");
          }
        });
  }

  Widget _titleDecoration(BuildContext context) {
    return Container(
        color: Theme.of(context).primaryColor.withOpacity(0.7),
        height: 35,
        width: 60,
        //margin: EdgeInsets.only(right: 10),
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.01)
          ..rotateX(0.9));
  }

  Widget _titleRow(BuildContext context, String title,
      {bool decoration = true}) {
    const double padding = 8.0;

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
          child: Row(
            children: [
              decoration ? _titleDecoration(context) : Container(),
              Text(
                title,
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
          padding: EdgeInsets.only(bottom: padding, top: padding)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bodyContent: [
        Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: Column(
            children: [
              _titleRow(context, "Harjoitus", decoration: false),
              _inputWorkoutName(),
              _titleRow(context, "Toistot", decoration: false),
              _inputGridButtonNumberInput(20, context),
              _titleRow(context, "Paino", decoration: false),
              _sliderInput(),
              _submitButton(),
              _titleRow(context, "Viimeisin setti", decoration: false),
              _latestWorkoutSection()
            ],
          ),
        )
      ],
      navBarIndex: 0,
      expanded: true,
    );
  }
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
