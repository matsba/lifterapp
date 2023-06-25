import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifterapp/common_widgets/info_text.dart';
import 'package:lifterapp/common_widgets/title_row.dart';
import 'package:lifterapp/features/workouts/domain/session.dart';
import 'package:lifterapp/features/workouts/domain/workout.dart';
import 'package:lifterapp/features/workouts/presentation/list_page_controller.dart';
import 'package:lifterapp/utils/formatter.dart';

class ListPage extends StatelessWidget {
  static String get routeName => 'list';
  static String get routeLocation => '/list';

  @override
  Widget build(BuildContext context) {
    return Container(child: SessionsList());
  }
}

class SessionsList extends ConsumerWidget {
  final List<String> _cardImages = [
    "assets/card-1.jpg",
    "assets/card-2.jpg",
    "assets/card-3.jpg",
    "assets/card-4.jpg",
  ];

  Widget _buildWorkoutCardList(
      BuildContext context, int index, List<Session> sessions) {
    Session session = sessions[index];
    List<Workout> workouts = session.workouts;

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
                      _cardImages[session.number % _cardImages.length],
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
                            '#${session.number}',
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
                            session.date,
                          )
                        ]),
                  ),
                ),
              ]),
              Column(children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: workouts.length,
                  itemBuilder: (BuildContext context, int index) =>
                      _buildWorkoutList(context, index, workouts),
                )
              ]),
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [Text("Kuorma: ${session.trainingVolume}")],
                ),
              )
            ],
          ),
        ));
  }

  Widget _buildWorkoutList(
      BuildContext context, int i, List<Workout> workouts) {
    var workout = workouts[i];
    var formatter = Formatter();

    return ListTile(
        isThreeLine: true,
        leading: _listIcon(context, i),
        title: Padding(
          key: Key("${workout.exercise.name}_${workout.id}"),
          padding: const EdgeInsets.only(bottom: 8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TitleRow(
              workout.exercise.name,
            ),
            ...workout.formattedSets.map((x) => Text(x)).toList(),
          ]),
        ),
        subtitle: Column(
          children: [
            InfoText(
              "= ${workout.trainingVolume} kuorma",
            ),
            workout.hasSets
                ? InfoText(
                    "${formatter.hoursMinutes(workout.startTime!)} - ${formatter.hoursMinutes(workout.endTime!)}")
                : Text(""),
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
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(sessionListProvider);

    return sessions.when(
        data: (sessions) {
          if (sessions.isNotEmpty) {
            return ListView.builder(
                key: const Key("session_list"),
                shrinkWrap: true,
                itemCount: sessions.length,
                itemBuilder: (BuildContext context, int index) =>
                    _buildWorkoutCardList(context, index, sessions));
          } else {
            return const Text("Ei vielä treenejä!");
          }
        },
        error: (err, stack) => Text("Virhe!"),
        loading: () => Text("Ladataan..."));
  }
}
