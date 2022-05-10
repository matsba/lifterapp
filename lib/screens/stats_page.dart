import 'package:flutter/material.dart';
import 'package:lifterapp/containers/ordinal_workout_volume_stats.dart';
import 'package:lifterapp/containers/workout_volume_stats.dart';
import 'package:lifterapp/containers/year_workout_activity_stats.dart';
import 'package:lifterapp/components/title_row.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const TitleRow("Tilastot", isHeading: true),
              const SizedBox(
                height: 8,
              ),
              YearWorkoutActivityStats(),
              OrdinalWorkoutVolumeStats(),
              WorkoutVolumeStats(),
            ],
          )),
    );
  }
}
