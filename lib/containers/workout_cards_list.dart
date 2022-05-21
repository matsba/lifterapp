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
  final List<String> _cardImages = [
    "lib/assets/card-1.jpg",
    "lib/assets/card-2.jpg",
    "lib/assets/card-3.jpg",
    "lib/assets/card-4.jpg",
  ];

  Widget _buildWorkoutCardList(
      BuildContext context, int index, List<WorkoutCard> cards) {
    WorkoutCard card = cards[index];
    List<WorkoutNameGroup> groups = card.groupWorkoutsByName.reversed.toList();
    int cardNumber = cards.length - index;

    return Container(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 3.0,
          child: Column(
            children: [
              Stack(children: [
                ColorFiltered(
                  child: Container(
                    height: 8 * 11,
                    width: double.infinity,
                    child: Image.asset(
                      _cardImages[cardNumber % _cardImages.length],
                      fit: BoxFit.cover,
                    ),
                  ),
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primaryContainer,
                      BlendMode.color),
                ),
                Card(
                  color: Colors.white,
                  margin: EdgeInsets.all(8),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    width: 100,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '#$cardNumber',
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    shadows: [
                                  const Shadow(
                                      color: Colors.black,
                                      offset: Offset(1, 1),
                                      blurRadius: 1)
                                ]),
                          ),
                          Text(
                            card.date,
                          )
                        ]),
                  ),
                ),
              ]),
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
                        const Icon(
                          Icons.timer_outlined,
                          color: Colors.black26,
                        ),
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
            return const Text("Ei vielä treenejä!");
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
