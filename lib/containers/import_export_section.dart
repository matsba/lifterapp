import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:lifterapp/components/info_snackbar.dart';
import 'package:lifterapp/middleware/app_middleware.dart';
import 'package:lifterapp/models/app_state.dart';
import 'package:lifterapp/models/workout.dart';
import 'package:lifterapp/selectors/selectors.dart';
import 'package:redux/redux.dart';

class ImportExportSection extends StatelessWidget {
  Future<void> _exportData(BuildContext context, List<Workout> log) async {
    final filePath = await FlutterFileDialog.saveFile(
        params: SaveFileDialogParams(
            data: Uint8List.fromList(utf8.encode(_buildCsvString(log))),
            fileName: "export.csv"));

    if (filePath != null && filePath.isNotEmpty) {
      InfoSnackbarBuilder(
              title: "Tiedot tuotu!",
              subtitle: filePath,
              icon: Icons.save_outlined)
          .show(context);
    }
  }

  Future<void> _importData(
      BuildContext context, Function importCallback) async {
    final filePath = await FlutterFileDialog.pickFile(
        params: const OpenFileDialogParams(
            dialogType: OpenFileDialogType.document));

    if (filePath == null || filePath.isEmpty) {
      return;
    }

    final file = File(filePath);
    final fileType = filePath.substring(file.path.length - 4);

    if (fileType != ".csv") {
      InfoSnackbarBuilder(
              title: "Vain .csv tiedostot sallittu",
              icon: Icons.error,
              isError: true)
          .show(context);
      return;
    }
    final List<String> rawWorkoutList = await file.readAsLines();

    if (rawWorkoutList.length < 2) {
      return;
    }

    final List<Workout> workouts = rawWorkoutList
        .skip(1) //skip header row
        .map((x) => _convertCsvStringToWorkout(x))
        .toList();

    //TODO: Implement error handling for dispatching events. See example: https://github.com/fluttercommunity/redux.dart/blob/master/doc/async.md
    await importCallback(workouts);

    InfoSnackbarBuilder(
            title: "Tiedosto tallennettu!",
            icon: Icons.save_outlined,
            subtitle: "(${workouts.length - 1} riviä)")
        .show(context);
  }

  String _buildCsvString(List<Workout> log) {
    String headerRow = "id,name,reps,weigth,body_weigth,timestamp";
    List<String> rows = log
        .map((x) => [x.id, x.name, x.reps, x.weigth, x.bodyWeigth, x.timestamp]
            .join(","))
        .toList();
    return "$headerRow\n${rows.join("\n")}";
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

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromStore(store),
        builder: (context, vm) {
          return Row(
            children: [
              IconButton(
                icon: const Icon(Icons.upload),
                onPressed: () => _importData(context, vm.import),
                disabledColor: Colors.black26,
              ),
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: () => _exportData(context, vm.workouts),
              ),
            ],
          );
        });
  }
}

class _ViewModel {
  final List<Workout> workouts;
  final Function(List<Workout>) import;

  _ViewModel({required this.workouts, required this.import});

  static fromStore(Store<AppState> store) => _ViewModel(
      workouts: logStateSelector(store.state).rawWorkouts,
      import: (List<Workout> workouts) =>
          store.dispatch(importWorkoutList(workouts)));
}
