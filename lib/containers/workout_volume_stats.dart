import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:lifterapp/components/info_text.dart';
import 'package:lifterapp/components/title_row.dart';
import 'package:lifterapp/models/app_state.dart';
import 'package:lifterapp/models/month_workout_volume_statistics.dart';
import 'package:lifterapp/selectors/selectors.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkoutVolumeStats extends StatelessWidget {
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
    return StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromStore(store),
        builder: (context, vm) {
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
                      value:
                          vm.workoutVolumeStatistics.ratio?.toStringAsFixed(2)),
                ],
              ),
              TextButton(
                onPressed: () => launch(
                    "https://www.shape.com/fitness/tips/training-volume-basics-lifting-weights"),
                child: const Text("Lue lisää"),
              ),
            ],
          );
        });
  }
}

class _ViewModel {
  MonthWorkoutVolumeStatistics workoutVolumeStatistics;

  _ViewModel(this.workoutVolumeStatistics);

  static fromStore(Store<AppState> store) =>
      _ViewModel(workoutVolumeStatisticsSelectior(store.state.statsState));
}
