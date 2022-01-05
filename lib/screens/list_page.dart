import 'package:flutter/material.dart' hide NavigationDestination;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:lifterapp/app_middleware.dart';
import 'package:lifterapp/app_state.dart';
import 'package:lifterapp/models/workout.dart' show WorkoutCard, WorkoutMinimal;

class ListPage extends StatelessWidget {
  Widget _buildWorkoutCardList(
      BuildContext context, int i, List<WorkoutCard> cards) {
    WorkoutCard card = cards[i];
    List<List<WorkoutMinimal>> groups =
        card.groupWorkoutsByName.reversed.toList();
    int cardNumber = cards.length - i;

    return Container(
        padding: EdgeInsets.only(bottom: 16),
        child: Card(
          child: Column(
            children: [
              ListTile(
                //leading: Icon(Icons.fitness_center),
                title: Text('Treeni #${cardNumber}',
                    style: Theme.of(context).textTheme.headline1),
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
                child: Row(
                  children: [
                    const Icon(Icons.timer),
                    Text("Kesto: ${card.duration}")
                  ],
                ),
                padding: EdgeInsets.all(10),
              )
            ],
          ),
          elevation: 3.0,
        ));
  }

  Widget _buildWorkoutList(
      BuildContext context, int i, List<List<WorkoutMinimal>> workouts) {
    List<WorkoutMinimal> details = workouts[i].reversed.toList();

    var baseTitle = details.map((x) => Text(x.setsRepsWeigth)).toList();
    baseTitle.insert(
        0,
        Text(
          details.first.name,
          style: Theme.of(context).textTheme.headline4,
        ));

    return ListTile(
        leading: CircleAvatar(
          //backgroundColor: Colors.black12,
          maxRadius: 20,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            (i + 1).toString(),
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        isThreeLine: true,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: baseTitle),
        ),
        subtitle: Text(
            "${DateFormat.Hm().format(details.first.firstTimestamp).toString()} - ${DateFormat.Hm().format(details.last.lastTimestamp).toString()}"));
  }

  Widget _workoutCardsList() {
    return StoreConnector<AppState, _WorkoutCardListViewModel>(
        converter: (store) => _WorkoutCardListViewModel(
            store.state.workoutCards, () => store.dispatch(getWorkoutCards())),
        builder: (context, vm) {
          if (vm.cards.isNotEmpty) {
            return ListView.builder(
                //scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: vm.cards.length,
                itemBuilder: (BuildContext context, int index) =>
                    _buildWorkoutCardList(context, index, vm.cards)
                //dragStartBehavior: DragStartBehavior.down,
                );
          } else {
            return Expanded(
                child: Text("Ei treenejä vielä!")); //TODO: empty state
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(16.0), child: _workoutCardsList()));
  }
}

class _WorkoutCardListViewModel {
  final List<WorkoutCard> cards;
  final dynamic getWorkoutCards;

  _WorkoutCardListViewModel(this.cards, this.getWorkoutCards);
}
