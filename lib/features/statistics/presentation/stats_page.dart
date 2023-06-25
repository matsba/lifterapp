import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifterapp/common_widgets/info_text.dart';
import 'package:lifterapp/common_widgets/title_row.dart';
import 'package:lifterapp/features/statistics/domain/ordinal_workout_volume_statistics.dart';
import 'package:lifterapp/features/statistics/presentation/stats_page_controller.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:url_launcher/url_launcher_string.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({Key? super.key});
  static String get routeName => 'stats';
  static String get routeLocation => '/stats';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const TitleRow("Tilastot", isHeading: true),
              const SizedBox(
                height: 8,
              ),
              YearWorkoutActivityStats(),
              OrdinalWorkoutVolumeStats(),
              WorkoutVolumeStats(),
            ],
          )),
    );
  }
}

class YearWorkoutActivityStats extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final yearWorkoutActivity = ref.watch(yearWorkoutActivityProvider);

    return yearWorkoutActivity.when(
        data: (data) {
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
                  itemCount: data.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) => Container(
                      child: const Text(""),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(_opacityForBox(data[index])),
                        border: Border.all(
                          color: Colors.white,
                        ),
                      ))),
            ],
          );
        },
        error: (err, stack) => Text("Virhe!"),
        loading: () => Text("Ladataan!"));
  }
}

class OrdinalWorkoutVolumeStats extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(ordinalWorkoutStatisticsFilterProvider);
    final ordinalWorkoutStatistics =
        ref.watch(ordinalWorkoutStatisticsProvider(filter ?? "Kaikki"));

    return ordinalWorkoutStatistics.when(
        data: (data) {
          return Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              const TitleRow("Treenivoluumit"),
              const InfoText("Sisältää vain treenit jotka tehty painoilla"),
              if (data.ordinalWorkoutVolumes.isNotEmpty)
                Column(children: [
                  Container(
                    width: 200,
                    child: DropdownButton(
                        isExpanded: true,
                        value: data.selectedFilter,
                        items: data.exerciseNames
                            .map((name) => DropdownMenuItem(
                                  child: Text(name),
                                  value: name,
                                ))
                            .toList(),
                        onChanged: (String? newValue) => ref
                            .read(
                                ordinalWorkoutStatisticsFilterProvider.notifier)
                            .state = newValue),
                  ),
                  SizedBox(
                    child: _WorkoutVolumesBarChart(
                      data.ordinalWorkoutVolumes,
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
        },
        error: (err, stack) => Text("Virhe!"),
        loading: () => Text("Ladataan!"));
  }
}

class _WorkoutVolumesBarChart extends StatelessWidget {
  final List<OridnalWorkoutVolume> data;
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

  List<charts.Series<OridnalWorkoutVolume, String>> _formatToSeries(
      BuildContext context) {
    return [
      charts.Series<OridnalWorkoutVolume, String>(
        id: 'WorkoutVolumes',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            Theme.of(context).colorScheme.secondary),
        domainFn: (OridnalWorkoutVolume workouts, _) => workouts.group,
        measureFn: (OridnalWorkoutVolume workouts, _) => workouts.volume,
        data: data,
      )
      // data: data.length < 10
      //     ? data
      //     : data.getRange(data.length - 10, data.length).toList()),
    ];
  }
}

class WorkoutVolumeStats extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    var statistics = ref.watch(monthWorkoutStatisticsProvider);

    return statistics.when(
        data: (data) {
          return Column(
            children: [
              const TitleRow("Voluumi jakaumat"),
              const InfoText("Sisältää vain treenit jotka tehty painoilla"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _singleStatPanel(
                      title: "Akuutti",
                      tooltip:
                          'Tyypillisesti tämä on urheilijan suorittama työmäärä 1 viikossa (7 päivää). Tämä arvo sisältää sekä harjoitus- että ottelun lataustiedot tämän 7 päivän jakson aikana. Juuri tämä luku esitetään ACWR:n "väsymyksenä".',
                      value: data.formattedAcuteLoad),
                  _singleStatPanel(
                      title: "Krooninen",
                      tooltip:
                          'Krooninen työmäärä on tyypillisesti 4 viikon (28 päivän) keskimääräinen akuutti työmäärä. Tämä arvo on tärkeä, koska se antaa selkeän kuvan siitä, mitä urheilija on tehnyt ennen nykyistä harjoitus- tai ottelupäivää. Siksi sitä pidetään yleisesti osoituksena urheilijan "kunnosta".',
                      value: data.formattedChronicLoad),
                  _singleStatPanel(
                      title: "Suhde",
                      tooltip:
                          'Itse suhde lasketaan jakamalla akuutti työmäärä (väsymys) kroonisella kuormituksella (kunto). Esimerkiksi akuutti työmäärä 1400 AU voidaan jakaa kroonisella työmäärällä 1500 AU, jolloin ACWR on 0,93 (1400 / 1500 = 0,93).',
                      value: data.formattedRatio),
                ],
              ),
              TextButton(
                onPressed: () => launchUrlString(
                    "https://www.shape.com/fitness/tips/training-volume-basics-lifting-weights"),
                child: const Text("Lue lisää"),
              ),
            ],
          );
        },
        error: (err, stack) => Text("Virhe!"),
        loading: () => Text("Ladataan!"));
  }
}
