import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:lifterapp/actions/app_actions.dart';
import 'package:lifterapp/components/info_text.dart';
import 'package:lifterapp/components/title_row.dart';
import 'package:lifterapp/models/app_state.dart';
import 'package:lifterapp/models/form_input_view_model.dart';
import 'package:lifterapp/models/workout_name_group.dart';
import 'package:lifterapp/selectors/selectors.dart';
import 'package:redux/redux.dart';

class InputWorkoutName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromStore(store),
        builder: (context, vm) {
          return Column(
            children: [
              TitleRow("Harjoitus"),
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }
                  return vm.workoutNames.where((String option) {
                    return option
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
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
              ),
              if (vm.findLatestWorkout(vm.value) != null)
                _LatestWorkoutCard(vm.findLatestWorkout(vm.value)!)
            ],
          );
        });
  }
}

class _LatestWorkoutCard extends StatelessWidget {
  final WorkoutNameGroup latestWorkoutNameGroup;

  const _LatestWorkoutCard(this.latestWorkoutNameGroup);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoText(
                        "Viimeisin setti (${latestWorkoutNameGroup.workouts.first.dateFormat})"),
                    SizedBox(height: 2),
                    ...latestWorkoutNameGroup.workouts.reversed
                        .map(
                          (element) => Text(element.setFormat),
                        )
                        .toList()
                  ],
                )
              ],
            )));
  }
}

class _ViewModel extends FormInputViewModel {
  final List<String> workoutNames;
  WorkoutNameGroup? Function(String) findLatestWorkout;

  _ViewModel(
      {required this.workoutNames,
      required value,
      required updateValue,
      required this.findLatestWorkout})
      : super(value: value, updateValue: updateValue);

  static fromStore(Store<AppState> store) => _ViewModel(
      workoutNames: workoutNamesSelector(store.state.logState),
      findLatestWorkout: (value) =>
          latestWorkoutGroupSelector(store.state.listState, value),
      value: workoutFormInputNameSelector(store.state.addWorkoutState),
      updateValue: (value) =>
          store.dispatch(UpdateWorkoutFormInputAction({"name": value})));
}
