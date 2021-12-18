import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart' hide NavigationDestination;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:lifterapp/app_middleware.dart';
import 'package:lifterapp/app_state.dart';
import 'package:lifterapp/components/app_scaffold.dart';
import 'package:lifterapp/components/bottom_navigationbar.dart';
import 'package:lifterapp/models/workout.dart'
    show WorkoutCard, WorkoutGroup, WorkoutMinimal;

class ListPage extends StatelessWidget {
  Widget _buildWorkoutCardList(
      BuildContext context, int i, List<WorkoutCard> cards) {
    WorkoutCard card = cards[i];

    return Container(
        padding: EdgeInsets.only(bottom: 16),
        child: Card(
          child: Column(
            children: [
              ListTile(
                //leading: Icon(Icons.fitness_center),
                title: Text('Treeni #${i + 1}',
                    style: Theme.of(context).textTheme.headline1),
                subtitle: Text(card.date),
              ),
              Column(children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: card.workouts.length,
                  itemBuilder: (BuildContext context, int index) =>
                      _buildWorkoutList(context, index, card.workouts),
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
      BuildContext context, int i, List<WorkoutMinimal> workouts) {
    WorkoutMinimal details = workouts[i];

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
        title: Text("${details.name} ${details.setsRepsWeigth}"),
        subtitle: Text(
            "${DateFormat.Hm().format(details.firstTimestamp).toString()} - ${DateFormat.Hm().format(details.lastTimestamp).toString()}"));
  }

  Widget _workoutCardsList() {
    return StoreConnector<AppState, _WorkoutCardListViewModel>(
        converter: (store) => _WorkoutCardListViewModel(
            store.state.workoutCards, () => store.dispatch(getWorkoutCards())),
        builder: (context, vm) {
          return Flexible(
              child: ListView.builder(
            //scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: vm.cards.length,
            itemBuilder: (BuildContext context, int index) =>
                _buildWorkoutCardList(context, index, vm.cards),
            //dragStartBehavior: DragStartBehavior.down,
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bodyContent: [_workoutCardsList()],
      navBarIndex: 1,
    );
  }
}

class _WorkoutCardListViewModel {
  final List<WorkoutCard> cards;
  final dynamic getWorkoutCards;

  _WorkoutCardListViewModel(this.cards, this.getWorkoutCards);
}
