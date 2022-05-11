import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:lifterapp/components/title_row.dart';
import 'package:lifterapp/containers/import_export_section.dart';
import 'package:lifterapp/middleware/app_middleware.dart';
import 'package:lifterapp/models/app_state.dart';
import 'package:lifterapp/models/workout.dart';
import 'package:lifterapp/selectors/selectors.dart';
import 'package:redux/redux.dart';

class WorkoutLog extends StatelessWidget {
  Widget _workoutLog(BuildContext context, List<Workout> log) {
    return PaginatedDataTable(
      columns: const [
        DataColumn(label: Text("Aika")),
        DataColumn(label: Text("Harjoitus")),
        DataColumn(label: Text("Toistot")),
        DataColumn(label: Text("Paino")),
      ],
      source: _RowSource(workouts: log, context: context),
      columnSpacing: 8.0,
      dataRowHeight: 30,
      rowsPerPage: 15,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromStore(store),
        builder: (context, vm) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TitleRow("Treeniloki", isHeading: true),
                        ImportExportSection()
                      ],
                    ),
                    _workoutLog(context, vm.workouts),
                  ]),
            ),
          );
        });
  }
}

class _ViewModel {
  final List<Workout> workouts;
  Function(int) delete;

  int get numberOfWorkouts => workouts.length;

  _ViewModel({required this.workouts, required this.delete});
  static fromStore(Store<AppState> store) => _ViewModel(
      workouts: logStateSelector(store.state).rawWorkouts,
      delete: (int id) => store.dispatch(deleteWorkout(id)));
}

class _RowSource extends DataTableSource {
  List<Workout> workouts;
  BuildContext context;

  get reversedWorkoutList => workouts.reversed.toList();

  _RowSource({required this.workouts, required this.context});

  @override
  DataRow? getRow(int index) {
    if (index < rowCount) {
      Workout workout = reversedWorkoutList[index];
      return DataRow(
          cells: [
            DataCell(Text(DateFormat("d.M.y H:mm").format(workout.timestamp))),
            DataCell(Text(workout.name)),
            DataCell(Text(workout.reps.toString())),
            workout.bodyWeigth
                ? const DataCell(Text(""))
                : DataCell(Text(workout.weigth.toString() + " kg")),
          ],
          onLongPress: () async => await showDialog(
              context: context,
              builder: (context) => _ShowDialog(workout: workout)));
    } else
      return null;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => workouts.length;

  @override
  int get selectedRowCount => 0;
}

class _ShowDialog extends StatelessWidget {
  Workout workout;

  _ShowDialog({required this.workout});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromStore(store),
        builder: (context, vm) {
          return SimpleDialog(
            title: Text(workout.name),
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
                        ? const Text("Kehonpaino")
                        : Text("Paino: ${workout.weigth}"),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SimpleDialogOption(
                    onPressed: () {
                      vm.delete(workout.id!);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Poista',
                      style: TextStyle(
                          color: Colors.redAccent, fontWeight: FontWeight.bold),
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
  }
}
