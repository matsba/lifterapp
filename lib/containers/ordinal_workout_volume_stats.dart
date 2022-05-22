import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:lifterapp/components/info_text.dart';
import 'package:lifterapp/components/title_row.dart';
import 'package:lifterapp/middleware/app_middleware.dart';
import 'package:lifterapp/models/app_state.dart';
import 'package:lifterapp/models/ordinal_workout_volumes.dart';
import 'package:lifterapp/selectors/selectors.dart';
import 'package:redux/redux.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class OrdinalWorkoutVolumeStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromStore(store),
        builder: (context, vm) {
          return Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              const TitleRow("Treenivoluumit"),
              const InfoText("Sisältää vain treenit jotka tehty painoilla"),
              if (vm.ordinalWorkoutVolumes.isNotEmpty)
                Column(children: [
                  Container(
                    width: 200,
                    child: DropdownButton(
                        isExpanded: true,
                        value: vm.selectedFilter,
                        items: vm.workoutNames
                            .map((name) => DropdownMenuItem(
                                  child: Text(name),
                                  value: name,
                                ))
                            .toList(),
                        onChanged: (String? newValue) =>
                            vm.filterWorkouts(newValue)),
                  ),
                  SizedBox(
                    child: _WorkoutVolumesBarChart(
                      vm.ordinalWorkoutVolumes,
                      animate: true,
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                  ),
                  const Text("Viikko / Vuosi"),
                ])
              else
                const Text("Ei treenejä")
            ],
          );
        });
  }
}

class _ViewModel {
  List<OridnalWorkoutVolumes> ordinalWorkoutVolumes;
  Function(String?) filterWorkouts;
  List<String> workoutNames;

  String get selectedFilter => ordinalWorkoutVolumes.isNotEmpty
      ? ordinalWorkoutVolumes.first.name
      : "Kaikki";

  _ViewModel(
      {required this.ordinalWorkoutVolumes,
      required this.filterWorkouts,
      required this.workoutNames});

  static fromStore(Store<AppState> store) => _ViewModel(
      ordinalWorkoutVolumes:
          ordinalWorkoutVolumesSelector(store.state.statsState),
      workoutNames:
          workoutNamesWithoutBodyweightAndAllSelector(store.state.logState),
      filterWorkouts: (value) =>
          store.dispatch(getOrdinalWorkoutVolumes(value)));
}

class _WorkoutVolumesBarChart extends StatelessWidget {
  final List<OridnalWorkoutVolumes> data;
  final bool animate;

  String get viewPortStartingDomain =>
      data.where((element) => element.volume > 0).last.group;
  int get viewPortStaringDataSize => 10;
  //     ? data
  //     : data.getRange(data.length - 10, data.length).toList()),

  _WorkoutVolumesBarChart(this.data, {required this.animate});

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      data.isNotEmpty ? _formatToSeries(context) : [],
      animate: animate,
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(labelRotation: 60),
        viewport: charts.OrdinalViewport(
            viewPortStartingDomain, viewPortStaringDataSize),
      ),
      behaviors: [
        charts.SlidingViewport(),
        charts.PanBehavior(),
      ],
    );
  }

  List<charts.Series<OridnalWorkoutVolumes, String>> _formatToSeries(
      BuildContext context) {
    return [
      charts.Series<OridnalWorkoutVolumes, String>(
        id: 'WorkoutVolumes',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            Theme.of(context).colorScheme.secondary),
        domainFn: (OridnalWorkoutVolumes workouts, _) => workouts.group,
        measureFn: (OridnalWorkoutVolumes workouts, _) => workouts.volume,
        data: data,
      )
      // data: data.length < 10
      //     ? data
      //     : data.getRange(data.length - 10, data.length).toList()),
    ];
  }
}
