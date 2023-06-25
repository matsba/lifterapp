import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifterapp/common_widgets/info_text.dart';
import 'package:lifterapp/features/workouts/presentation/add_workout_page_controller.dart';
import 'package:lifterapp/features/workouts/presentation/list_page_controller.dart';
import 'package:lifterapp/utils/formatter.dart';

class LatestWorkoutCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var name =
        ref.watch(addWorkoutFormProvider.select((value) => value.exerciseName));
    var formatter = Formatter();

    if (name.isEmpty) {
      debugPrint("LatestWorkoutCard name is empty");
      return Text("");
    }

    return ref.watch(latestWorkoutProvider(name)).when(
        data: (latestWorkout) {
          if (latestWorkout == null) {
            return Text("");
          }
          debugPrint("Got for workout LatestWorkoutCard: $latestWorkout");
          if (latestWorkout == null) {
            return Text("");
          }
          return Card(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.5),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      latestWorkout.hasSets
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InfoText(
                                    "Viimeisin setti (${formatter.shortDate(latestWorkout.startTime!)})"),
                                SizedBox(height: 2),
                                ...latestWorkout.formattedSets
                                    .map(
                                      (element) => Text(element),
                                    )
                                    .toList()
                              ],
                            )
                          : Text("Ei settejä!")
                    ],
                  )));
        },
        error: (err, stack) => Text("Virhe ladattaessa viimeisintä treeniä!"),
        loading: () => Text(""));
  }
}
