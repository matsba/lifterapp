import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:lifterapp/components/info_snackbar.dart';
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
          return Container(
            height: 60,
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                vm.updateValue(vm.value);

                InfoSnackbarBuilder(
                        title: "${vm.value.name} lisätty!", icon: Icons.star)
                    .show(context);
              },
              child: Text('Lisää'),
            ),
          );
        });
  }
}

class _ViewModel extends FormInputViewModel {
  final WorkoutGroup? latestWorkout;

  _ViewModel(
      {required this.latestWorkout,
      required super.value,
      required super.updateValue});

  static fromStore(Store<AppState> store) => _ViewModel(
      latestWorkout: store.state.addWorkoutState.latestWorkout,
      value: store.state.addWorkoutState.workoutFormInput,
      updateValue: (form) => store.dispatch(insertWorkout(form!)));
}
