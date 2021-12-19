import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:lifterapp/app_middleware.dart';
import 'package:lifterapp/app_state.dart';
import 'package:lifterapp/components/app_scaffold.dart';
import 'package:lifterapp/models/workout.dart';

class LogPage extends StatelessWidget {
  DataRow _workoutLogRow(Workout workout, menuCallback) {
    return DataRow(
      cells: [
        DataCell(Text(DateFormat("d.M.y H:mm").format(workout.timestamp))),
        DataCell(Text(workout.name)),
        DataCell(Text(workout.reps.toString())),
        workout.bodyWeigth
            ? const DataCell(Text(""))
            : DataCell(Text(workout.weigth.toString() + " kg")),
      ],
      onLongPress: () => menuCallback(workout),
    );
  }

  Future<void> _showLogRowMenu(BuildContext context, Workout workout) async {
    await showDialog(
        context: context,
        builder: (context) {
          return StoreConnector<AppState, Function(int)>(
              converter: (store) =>
                  (int id) => store.dispatch(deleteWorkout(id)),
              builder: (context, deleteCallback) {
                return SimpleDialog(
                  title: Text("${workout.name}"),
                  titleTextStyle: Theme.of(context).textTheme.headline4,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 26.0, bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Aika: ${DateFormat("d.M.y H:mm").format(workout.timestamp)}"),
                          Text("Toistot: ${workout.reps}"),
                          workout.bodyWeigth
                              ? Text("Kehonpaino")
                              : Text("Paino: ${workout.weigth}"),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SimpleDialogOption(
                          onPressed: () {
                            deleteCallback(workout.id!);
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Poista',
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Sulje'),
                        ),
                      ],
                    ),
                  ],
                );
              });
        });
  }

  List<DataRow> _generateRows(List<Workout> log, menuCallback) {
    return log.map((x) => _workoutLogRow(x, menuCallback)).toList();
  }

  Widget _workoutLog(context) {
    return StoreConnector<AppState, List<Workout>>(
        converter: (store) => store.state.rawWorkouts,
        builder: (context, log) {
          return DataTable(
            columns: const [
              DataColumn(label: Text("Aika")),
              DataColumn(label: Text("Harjoitus")),
              DataColumn(label: Text("Toistot")),
              DataColumn(label: Text("Paino")),
            ],
            rows: _generateRows(log.reversed.toList(),
                (Workout workout) => _showLogRowMenu(context, workout)),
            columnSpacing: 8.0,
            dataRowHeight: 30,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bodyContent: Column(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Treeniloki",
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        Align(child: _workoutLog(context), alignment: Alignment.centerLeft),
        //TODO: Text("Sivun loppu")  pitkä lista ei näy loppuun asti
      ]),
      expanded: true,
    );
  }
}
