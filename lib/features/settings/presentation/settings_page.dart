import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lifterapp/common_widgets/app_scaffold.dart';
import 'package:lifterapp/common_widgets/info_snackbar.dart';
import 'package:lifterapp/common_widgets/title_row.dart';
import 'package:lifterapp/features/settings/presentation/settings_page_controller.dart';
import 'package:lifterapp/utils/formatter.dart';
import 'package:path/path.dart';

class SettingsPage extends StatelessWidget {
  static String get routeName => 'settings';
  static String get routeLocation => '/settings';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bodyContent: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const TitleRow("Asetukset", isHeading: true),
              RestingTimeSetting(),
            ],
          )),
    );
  }
}

class RestingTimeSetting extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var usingRestingTimeFeature = ref.watch(usingRestingTimeFeatureProvider);

    return Column(
      children: [
        TitleRow("Lepoaika"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Käytä lepoaikaa"),
            usingRestingTimeFeature.when(
                data: (data) => Switch(
                    key: Key("resting_time"),
                    value: data,
                    onChanged: (switchValue) => ref.read(
                        updateUsingRestingTimeFeatureProvider(switchValue))),
                error: (err, stack) => Text("Virhe!"),
                loading: () => Text("Ladataan!")),
          ],
        ),
        TitleRow("Vie tietoja"),
        ExportSection(),
        SizedBox(height: 16),
        TitleRow("Tuo tietoja"),
        ImportSection(),
      ],
    );
  }
}

class ExportSection extends ConsumerWidget {
  Formatter _formatter = Formatter();

  Future<void> _exportData(
      BuildContext context, Uint8List dataToExport, String fileFormat) async {
    final filePath = await FlutterFileDialog.saveFile(
        params: SaveFileDialogParams(
            data: dataToExport,
            fileName:
                "lifterapp_export_${_formatter.fileFrendlyDateTime(DateTime.now())}.$fileFormat"));

    if (filePath != null && filePath.isNotEmpty) {
      InfoSnackbarBuilder(
              title: "Tiedot tuotu!",
              subtitle: filePath,
              icon: Icons.save_outlined)
          .show(context);
    }
  }

  /*
  String _buildCsvString(List<WorkoutTableRow> log) {
    String headerRow = "id,name,reps,weigth,body_weigth,timestamp";
    List<String> rows = log
        .map((x) => [
              x.setId,
              x.exerciseName,
              x.reps,
              x.weigth,
              x.isBodyWeigth,
              x.timestamp
            ].join(","))
        .toList();
    return "$headerRow\n${rows.join("\n")}";
  }

  WorkoutTableRow _convertCsvStringToWorkout(String workoutRow) {
    List<String> splittedWorkoutRow = workoutRow.split(",");
    return WorkoutTableRow(
        setId: int.parse(splittedWorkoutRow[0]),
        exerciseName: splittedWorkoutRow[1],
        reps: int.parse(splittedWorkoutRow[2]),
        weigth: double.parse(splittedWorkoutRow[3]),
        isBodyWeigth: splittedWorkoutRow[4] == "true" ? true : false,
        timestamp: DateTime.parse(splittedWorkoutRow[5]));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.download),
          onPressed: () => _exportData(context, vm.workouts),
        ),
      ],
    );
  }
}
*/

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => print("test"), //_importData(context, ref),
          child: Row(
            children: [
              Text("Vie tietokanta .csv:nä"),
              SizedBox(width: 16),
              const Icon(Icons.file_copy)
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            var databaseExport = ref.watch(databaseExportProvider);
            databaseExport.whenData((data) => _exportData(context, data, "db"));
          },
          child: Row(
            children: [
              Text("Vie tietokantana"),
              SizedBox(width: 16),
              if (ref.watch(databaseExportProvider).isLoading)
                Text("Ladataan!"),
              const FaIcon(FontAwesomeIcons.database),
            ],
          ),
        ),
      ],
    );
  }
}

class ImportSection extends ConsumerWidget {
  Future<void> _importData(BuildContext context, WidgetRef ref) async {
    final filePath = await FlutterFileDialog.pickFile(
        params: const OpenFileDialogParams(
            dialogType: OpenFileDialogType.document));

    if (filePath == null || filePath.isEmpty) {
      return;
    }

    final file = File(filePath);
    final fileType = extension(file.path);

    if (![".csv", ".db"].contains(fileType)) {
      InfoSnackbarBuilder(
              title: "Vain .csv ja .db tiedostot sallittu",
              icon: Icons.error,
              isError: true)
          .show(context);
      return;
    }

    if (fileType == ".db") {
      Uint8List bytes = await file.readAsBytes();
      final result = ref.watch(databaseImportProvider(bytes));

      result.when(
          data: (data) {
            InfoSnackbarBuilder(
                    title: "Tiedosto tallennettu!", icon: Icons.save_outlined)
                .show(context);
          },
          error: (error, stack) {
            InfoSnackbarBuilder(
                    title: "Tiedoston tuominen epäonnistui!",
                    icon: Icons.error,
                    isError: true)
                .show(context);
            return;
          },
          loading: () => InfoSnackbarBuilder(
                  title: "Ladataan!", icon: Icons.hourglass_top, isError: false)
              .show(context));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => _importData(context, ref),
          child: Row(
            children: [
              Text("Tuo tietokanta"),
              SizedBox(width: 16),
              const FaIcon(FontAwesomeIcons.download),
            ],
          ),
        ),
      ],
    );
  }
}
