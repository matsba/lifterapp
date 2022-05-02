import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:lifterapp/app_actions.dart';
import 'package:lifterapp/app_middleware.dart';
import 'package:lifterapp/app_state.dart';
import 'package:lifterapp/components/info_text.dart';
import 'package:lifterapp/components/title_row.dart';
import 'package:lifterapp/models/workout.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({Key? key}) : super(key: key);

  Widget _singleStatPanel(
      {required String title, required String? value, String tooltip = ""}) {
    return Tooltip(
      message: tooltip,
      preferBelow: false,
      padding: const EdgeInsets.all(5),
      showDuration: const Duration(seconds: 5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [Text(title), TitleRow(value ?? "Ei dataa")]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _StatisticsViewModel>(
        converter: (store) => _StatisticsViewModel(
              ordinalWorkoutVolumes: store.state.ordinalWorkoutVolumes,
              workoutNames: store.state.workoutNamesWithoutBodyWeigth,
              workoutVolumeStatistics: store.state.workoutVolumeStatistics,
              yearWorkoutActivity: store.state.yearWorkoutActivity,
              filterWorkouts: (value) =>
                  store.dispatch(getOrdinalWorkoutVolumes(value)),
            ),
        builder: (context, vm) {
          return SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TitleRow(
                      "Tilastot",
                      isHeading: true,
                    ),
                    TitleRow(
                      "Treeniviikot",
                      isHeading: false,
                    ),
                    InfoText("Tavoite 3 kertaa viikossa"),
                    const SizedBox(
                      height: 8,
                    ),
                    GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 14,
                        ),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: vm.yearWorkoutActivity.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) =>
                            Container(
                                child: const Text(""),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryVariant
                                      .withOpacity(
                                          vm.yearWorkoutActivity[index] / 3 > 0
                                              ? vm.yearWorkoutActivity[index] /
                                                  3
                                              : 0.05),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                ))),
                    vm.ordinalWorkoutVolumes.isNotEmpty
                        ? Column(
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              TitleRow("Treenivoluumit"),
                              InfoText(
                                  "Sisältää vain treenit jotka tehty painoilla"),
                              DropdownButton(
                                  value: vm.selectedFilter,
                                  items: vm.allAndWorkoutNames
                                      .map((name) => DropdownMenuItem(
                                            child: Text(name),
                                            value: name,
                                          ))
                                      .toList(),
                                  onChanged: (String? newValue) =>
                                      vm.filterWorkouts(newValue)),
                              SizedBox(
                                child: WorkoutVolumesBarChart(
                                  vm.ordinalWorkoutVolumes,
                                  animate: true,
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: 250,
                              ),
                              const Text("Viikko / Vuosi")
                            ],
                          )
                        : const Text("Ei treenejä"),
                    Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        TitleRow("Voluumi jakaumat"),
                        InfoText("Sisältää vain treenit jotka tehty painoilla"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _singleStatPanel(
                                title: "Akuutti",
                                tooltip:
                                    'Tyypillisesti tämä on urheilijan suorittama työmäärä 1 viikossa (7 päivää). Tämä arvo sisältää sekä harjoitus- että ottelun lataustiedot tämän 7 päivän jakson aikana. Juuri tämä luku esitetään ACWR:n "väsymyksenä".',
                                value: vm.workoutVolumeStatistics.acuteLoad
                                    ?.toStringAsFixed(0)),
                            _singleStatPanel(
                                title: "Krooninen",
                                tooltip:
                                    'Krooninen työmäärä on tyypillisesti 4 viikon (28 päivän) keskimääräinen akuutti työmäärä. Tämä arvo on tärkeä, koska se antaa selkeän kuvan siitä, mitä urheilija on tehnyt ennen nykyistä harjoitus- tai ottelupäivää. Siksi sitä pidetään yleisesti osoituksena urheilijan "kunnosta".',
                                value: vm.workoutVolumeStatistics.chronicLoad
                                    ?.toStringAsFixed(0)),
                            _singleStatPanel(
                                title: "Suhde",
                                tooltip:
                                    'Itse suhde lasketaan jakamalla akuutti työmäärä (väsymys) kroonisella kuormituksella (kunto). Esimerkiksi akuutti työmäärä 1400 AU voidaan jakaa kroonisella työmäärällä 1500 AU, jolloin ACWR on 0,93 (1400 / 1500 = 0,93).',
                                value: vm.workoutVolumeStatistics.ratio
                                    ?.toStringAsFixed(2)),
                          ],
                        ),
                        TextButton(
                          onPressed: () => launch(
                              "https://www.scienceforsport.com/acutechronic-workload-ratio/"),
                          child: const Text("Lue lisää"),
                        ),
                      ],
                    )
                  ],
                )),
          );
        });
  }
}

class _StatisticsViewModel {
  List<OridnalWorkoutVolumes> ordinalWorkoutVolumes;
  List<String> workoutNames;
  Function(String?) filterWorkouts;
  MonthWorkoutVolumeStatistics workoutVolumeStatistics;
  List<int> yearWorkoutActivity;

  String get selectedFilter => ordinalWorkoutVolumes.isNotEmpty
      ? ordinalWorkoutVolumes.first.name
      : "Kaikki";

  List<String> get allAndWorkoutNames => ["Kaikki", ...workoutNames];

  _StatisticsViewModel(
      {required this.ordinalWorkoutVolumes,
      required this.workoutNames,
      required this.filterWorkouts,
      required this.workoutVolumeStatistics,
      required this.yearWorkoutActivity});
}

class WorkoutVolumesBarChart extends StatelessWidget {
  final List<OridnalWorkoutVolumes> data;
  final bool animate;

  WorkoutVolumesBarChart(this.data, {required this.animate});

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      data.isNotEmpty ? _formatToSeries(context) : [],
      animate: animate,
      domainAxis: const charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(labelRotation: 60),
      ),
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<OridnalWorkoutVolumes, String>> _formatToSeries(
      BuildContext context) {
    return [
      charts.Series<OridnalWorkoutVolumes, String>(
          id: 'WorkoutVolumes',
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(
              Theme.of(context).colorScheme.primary),
          domainFn: (OridnalWorkoutVolumes workouts, _) => workouts.group,
          measureFn: (OridnalWorkoutVolumes workouts, _) => workouts.volume,
          data: data.length < 10
              ? data
              : data.getRange(data.length - 10, data.length).toList()),
    ];
  }
}
