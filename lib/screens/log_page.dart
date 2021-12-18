import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:lifterapp/app_state.dart';
import 'package:lifterapp/components/app_scaffold.dart';
import 'package:lifterapp/models/workout.dart';

class LogPage extends StatelessWidget {
  DataRow _workoutLogRow(Workout workout) {
    return DataRow(cells: [
      DataCell(Text(DateFormat("d.M.y H:mm.ss").format(workout.timestamp))),
      DataCell(Text(workout.name)),
      DataCell(Text(workout.reps.toString())),
      workout.bodyWeigth
          ? const DataCell(Text(""))
          : DataCell(Text(workout.weigth.toString() + " kg"))
    ]);
  }

  List<DataRow> _generateRows(List<Workout> log) {
    return log.map((x) => _workoutLogRow(x)).toList();
  }

  Widget _workoutLog() {
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
            rows: _generateRows(log),
            columnSpacing: 16.0,
            dataRowHeight: 30,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(bodyContent: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Treeniloki",
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      SingleChildScrollView(
        child: _workoutLog(),
        scrollDirection: Axis.vertical,
      )
    ]);
  }
}
