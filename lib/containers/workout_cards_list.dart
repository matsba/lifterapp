import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:lifterapp/components/info_text.dart';
import 'package:lifterapp/components/title_row.dart';
import 'package:lifterapp/models/app_state.dart';
import 'package:lifterapp/models/workout_card.dart';
import 'package:lifterapp/models/workout_name_group.dart';
import 'package:lifterapp/selectors/selectors.dart';
import 'package:redux/redux.dart';

class WorkoutCardsList extends StatelessWidget {
  const WorkoutCardsList({Key? key}) : super(key: key);

  Widget _buildWorkoutCardList(
      BuildContext context, int index, List<WorkoutCard> cards) {
    WorkoutCard card = cards[index];
    List<WorkoutNameGroup> groups = card.groupWorkoutsByName.reversed.toList();
    int cardNumber = cards.length - index;

    return Container(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Card(
          elevation: 3.0,
          child: Column(
            children: [
              ListTile(
                title: TitleRow('Treeni #$cardNumber', isHeading: true),
                subtitle: Text(card.date),
              ),
              Column(children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: groups.length,
                  itemBuilder: (BuildContext context, int index) =>
                      _buildWorkoutList(context, index, groups),
                )
              ]),
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.timer),
                        const SizedBox(
                          width: 3,
                        ),
                        Text("Kesto: ${card.duration}"),
                      ],
                    ),
                    Text("Kuorma: ${card.overallVolume.toStringAsFixed(0)}")
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget _buildWorkoutList(
      BuildContext context, int i, List<WorkoutNameGroup> group) {
    var nameGroup = group[i];
    var workouts = nameGroup.workouts.reversed;

    return ListTile(
        isThreeLine: true,
        leading: _listIcon(context, i),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TitleRow(
              nameGroup.name,
            ),
            ...workouts.map((x) => Text(x.setFormat)).toList(),
          ]),
        ),
        subtitle: Column(
          children: [
            InfoText(
              "= ${nameGroup.trainingVolume.toStringAsFixed(0)} kuorma",
            ),
            InfoText(
                "${DateFormat.Hm().format(workouts.first.firstTimestamp).toString()} - ${DateFormat.Hm().format(workouts.last.lastTimestamp).toString()}"),
          ],
        ));
  }

  CircleAvatar _listIcon(BuildContext context, int i) {
    return CircleAvatar(
      maxRadius: 20,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Text(
        (i + 1).toString(),
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromStore(store),
        builder: (context, vm) {
          if (vm.cards.isNotEmpty) {
            return ListView.builder(
                //physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: vm.cards.length,
                itemBuilder: (BuildContext context, int index) =>
                    _buildWorkoutCardList(context, index, vm.cards));
          } else {
            return const Expanded(child: Text("Ei vielä treenejä!"));
          }
        });
  }
}

class _ViewModel {
  final List<WorkoutCard> cards;

  _ViewModel({required this.cards});

  static _ViewModel fromStore(Store<AppState> store) =>
      _ViewModel(cards: listStateSelector(store.state).workoutCards);
}
