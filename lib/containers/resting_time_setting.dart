import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:lifterapp/components/title_row.dart';
import 'package:lifterapp/middleware/app_middleware.dart';
import 'package:lifterapp/models/app_state.dart';
import 'package:lifterapp/models/form_input_view_model.dart';
import 'package:redux/redux.dart';

class RestingTimeSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromStore(store),
        builder: (context, vm) {
          var textController = TextEditingController(text: vm.value.toString());
          return Column(
            children: [
              TitleRow("Lepoaika"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Käytä lepoaikaa"),
                  Switch(
                      value: vm.usingRestingTime,
                      onChanged: vm.updateUsingRestingTime)
                ],
              ),
              if (vm.usingRestingTime)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Lepoajan pituus sekunneissa (max. 600)"),
                    Container(
                        width: 40,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: textController,
                          textAlign: TextAlign.center,
                          onEditingComplete: () =>
                              vm.updateValue(textController.text),
                        ))
                  ],
                )
            ],
          );
        });
  }
}

class _ViewModel extends FormInputViewModel {
  final bool usingRestingTime;
  final void Function(bool?) updateUsingRestingTime;

  _ViewModel(
      {required this.usingRestingTime,
      value,
      required this.updateUsingRestingTime,
      updateValue})
      : super(value: value, updateValue: updateValue);

  static fromStore(Store<AppState> store) => _ViewModel(
      usingRestingTime: store.state.settingsState.usingRestingTime,
      value: store.state.settingsState.restingTimeInSeconds,
      updateValue: (value) =>
          store.dispatch(updateRestingTimeSeconds(int.tryParse(value) ?? 0)),
      updateUsingRestingTime: (value) =>
          store.dispatch(updateUsingRestingTimeSetting(value ?? false)));
}
