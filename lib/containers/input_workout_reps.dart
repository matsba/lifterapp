import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:lifterapp/actions/app_actions.dart';
import 'package:lifterapp/components/title_row.dart';
import 'package:lifterapp/models/app_state.dart';
import 'package:lifterapp/models/form_input_view_model.dart';
import 'package:lifterapp/selectors/selectors.dart';
import 'package:redux/redux.dart';

class InputWorkoutReps extends StatelessWidget {
  final int countOfInputs;

  InputWorkoutReps({required this.countOfInputs});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromStore(store),
        builder: (context, vm) {
          var size = MediaQuery.of(context).size;

          _bgColor(stateValue, inputValue) {
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
                    crossAxisCount: 4,
                    childAspectRatio: (itemWidth / itemHeight)),
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
                          onPressed: () => vm.updateValue(inputValue),
                          style: OutlinedButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: _bgColor(vm.value!, inputValue),
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
        });
  }
}

class _ViewModel extends FormInputViewModel {
  _ViewModel({required super.value, required super.updateValue});

  static fromStore(Store<AppState> store) => _ViewModel(
      value: workoutFormInputRepsSelector(store.state.addWorkoutState),
      updateValue: (value) =>
          store.dispatch(UpdateWorkoutFormInputAction({"reps": value})));
}
