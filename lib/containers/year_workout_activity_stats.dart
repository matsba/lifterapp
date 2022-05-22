import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:lifterapp/components/info_text.dart';
import 'package:lifterapp/components/title_row.dart';
import 'package:lifterapp/models/app_state.dart';
import 'package:lifterapp/selectors/selectors.dart';
import 'package:redux/redux.dart';

class YearWorkoutActivityStats extends StatelessWidget {
  final goalForActivity = 3;

  double _opacityForBox(int activityLevel) {
    double activityRate = activityLevel / goalForActivity;
    if (activityRate > 1) {
      return 1;
    }
    if (activityRate > 0) {
      return activityRate;
    }
    return 0.05;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromStore(store),
        builder: (context, vm) {
          return Column(
            children: [
              const TitleRow("Treeniviikot", isHeading: false),
              const InfoText("Tavoite 3 kertaa viikossa"),
              GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 14,
                  ),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: vm.yearWorkoutActivity.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) => Container(
                      child: const Text(""),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(
                                _opacityForBox(vm.yearWorkoutActivity[index])),
                        border: Border.all(
                          color: Colors.white,
                        ),
                      ))),
            ],
          );
        });
  }
}

class _ViewModel {
  List<int> yearWorkoutActivity;

  _ViewModel(this.yearWorkoutActivity);

  static fromStore(Store<AppState> store) =>
      _ViewModel(yearWorkoutActivitySelector(store.state.statsState));
}
