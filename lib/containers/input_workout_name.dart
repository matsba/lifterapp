import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:lifterapp/actions/app_actions.dart';
import 'package:lifterapp/components/title_row.dart';
import 'package:lifterapp/models/app_state.dart';
import 'package:lifterapp/models/form_input_view_model.dart';
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
}

class _ViewModel extends FormInputViewModel {
  final List<String> workoutNames;

  _ViewModel({required this.workoutNames, required value, required updateValue})
      : super(value: value, updateValue: updateValue);

  static fromStore(Store<AppState> store) => _ViewModel(
      workoutNames: workoutNamesSelector(store.state.logState),
      value: workoutFormInputNameSelector(store.state.addWorkoutState),
      updateValue: (value) =>
          store.dispatch(UpdateWorkoutFormInputAction({"name": value})));
}
