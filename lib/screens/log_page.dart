import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
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
      _showSnackBar(context, filePath);
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

  void _showSnackBar(BuildContext context, String filePath) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tiedosto tallennettu sijaintiin:",
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                filePath,
              )
            ],
          ),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _importExportSection(BuildContext context, List<Workout> log) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.upload),
          onPressed: () => print("Not implemented upload"),
        ),
        IconButton(
          icon: Icon(Icons.download),
          onPressed: () => _exportData(context, log),
        ),
      ],
    );
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
                          Text(
                            "Treeniloki",
                            style: Theme.of(context).textTheme.headline1,
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
