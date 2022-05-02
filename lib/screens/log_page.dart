import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:lifterapp/app_middleware.dart';
import 'package:lifterapp/app_state.dart';
import 'package:lifterapp/components/app_scaffold.dart';
import 'package:lifterapp/components/title_row.dart';
import 'package:lifterapp/data/workout_repository.dart';
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

  Widget _workoutLog(BuildContext context, List<Workout> log) {
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
  }

  Future<void> _exportData(BuildContext context, List<Workout> log) async {
    final params = SaveFileDialogParams(
        data: Uint8List.fromList(utf8.encode(_buildCsvString(log))),
        fileName: "export.csv");
    final filePath = await FlutterFileDialog.saveFile(params: params);
    if (filePath != null && filePath.isNotEmpty) {
      _showExportSnackBar(context, filePath);
    }
  }

  Future<void> _importData(BuildContext context, Function callback) async {
    final params =
        OpenFileDialogParams(dialogType: OpenFileDialogType.document);
    final filePath = await FlutterFileDialog.pickFile(params: params);
    print("Loading file from $filePath");
    if (filePath == null || filePath.isEmpty) {
      return;
    }
    final file = File(filePath);
    final fileType = filePath.substring(file.path.length - 4);
    print(fileType);

    if (fileType != ".csv") {
      _showImportSnackBarFailed(context, "Vain .csv tiedostot sallittu");
      return;
    }
    final List<String> rawWorkoutList = await file.readAsLines();

    print("File has ${rawWorkoutList.length} rows");

    if (rawWorkoutList.length < 2) {
      return;
    }

    final List<Workout> workouts = rawWorkoutList
        .skip(1) //skip header row
        .map((x) => _convertCsvStringToWorkout(x))
        .toList();

    print("Converted to workout objects");

    try {
      //TODO: Implement error handling for dispatching events. See example: https://github.com/fluttercommunity/redux.dart/blob/master/doc/async.md
      await callback(workouts);
      _showImportSnackBarSuccess(context, workouts.length - 1);
    } catch (e) {
      _showImportSnackBarFailed(context, "Tietokanta virhe");
    }
  }

  String _buildCsvString(List<Workout> log) {
    String headerRow = "id,name,reps,weigth,body_weigth,timestamp";
    List<String> rows = log
        .map((x) => [x.id, x.name, x.reps, x.weigth, x.bodyWeigth, x.timestamp]
            .join(","))
        .toList();
    return headerRow + "\n" + rows.join("\n");
  }

  Workout _convertCsvStringToWorkout(String workoutRow) {
    List<String> splittedWorkoutRow = workoutRow.split(",");
    return Workout(
        id: int.parse(splittedWorkoutRow[0]),
        name: splittedWorkoutRow[1],
        reps: int.parse(splittedWorkoutRow[2]),
        weigth: double.parse(splittedWorkoutRow[3]),
        bodyWeigth: splittedWorkoutRow[4] == "true" ? true : false,
        timestamp: DateTime.parse(splittedWorkoutRow[5]));
  }

  void _showExportSnackBar(BuildContext context, String filePath) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.save_outlined),
              Text(
                "Tiedosto tallennettu!",
                style: Theme.of(context).textTheme.headline4,
              )
            ],
          ),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showImportSnackBarSuccess(BuildContext context, int numberOfWorkouts) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 40),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.new_releases),
                  Text(
                    "Tiedosto tuotu!",
                    style: Theme.of(context).textTheme.headline4,
                  )
                ],
              ),
              Text("($numberOfWorkouts riviä)"),
            ],
          ),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showImportSnackBarFailed(BuildContext context, String errorText) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 40),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.error),
                  Text(
                    "Tiedoston tuonti epäonnistui!",
                    style: Theme.of(context).textTheme.headline4,
                  )
                ],
              ),
              Text(errorText),
            ],
          ),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _importExportSection(BuildContext context, List<Workout> log) {
    return StoreConnector<AppState, Function>(
        converter: (store) =>
            (workouts) => store.dispatch(importWorkoutList(workouts)),
        builder: (context, callback) {
          return Row(
            children: [
              IconButton(
                icon: Icon(Icons.upload),
                onPressed: () => _importData(context, callback),
                disabledColor: Colors.black26,
              ),
              IconButton(
                icon: Icon(Icons.download),
                onPressed: () => _exportData(context, log),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bodyContent: StoreConnector<AppState, List<Workout>>(
          converter: (store) => store.state.rawWorkouts,
          builder: (context, log) {
            return SingleChildScrollView(
              child: Container(
                height: log.length * 37,
                padding: EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TitleRow(
                            "Treeniloki",
                            isHeading: true,
                          ),
                          _importExportSection(context, log)
                        ],
                      ),

                      _workoutLog(context, log),

                      //TODO: empty state   pitkä lista ei näy loppuun asti
                      SizedBox(
                        height: 16,
                      ),
                      Center(
                          child: Text(
                              "Siinä kaikki ${log.length} treeniä... 🥵")), //TODO: rajoita tätä jos suorituskyky onglaa pitkän listan kanssa
                    ]),
              ),
            );
          }),
    );
  }
}
