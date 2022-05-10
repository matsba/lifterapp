import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:lifterapp/components/info_snackbar.dart';
import 'package:lifterapp/components/title_row.dart';
import 'package:lifterapp/middleware/app_middleware.dart';
import 'package:lifterapp/models/app_state.dart';
import 'package:lifterapp/models/form_input_view_model.dart';
import 'package:lifterapp/models/workout_group.dart';
import 'package:redux/redux.dart';

class InputSubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromStore(store),
        builder: (context, vm) {
          return Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: ElevatedButton(
              onPressed: () {
                vm.updateValue(vm.value);

                InfoSnackbarBuilder(
                        title: "${vm.value.name} lisätty!", icon: Icons.star)
                    .show(context);
              },
              child: const SizedBox(
                  child: Center(child: Text('Lisää')), height: 50.0),
            ),
          );
        });
  }
}

class _ViewModel extends FormInputViewModel {
  final WorkoutGroup? latestWorkout;

  _ViewModel(
      {required this.latestWorkout, required value, required updateValue})
      : super(value: value, updateValue: updateValue);

  static fromStore(Store<AppState> store) => _ViewModel(
      latestWorkout: store.state.addWorkoutState.latestWorkout,
      value: store.state.addWorkoutState.workoutFormInput,
      updateValue: (form) => store.dispatch(insertWorkout(form!)));
}
