import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifterapp/common_widgets/info_snackbar.dart';
import 'package:lifterapp/common_widgets/info_text.dart';
import 'package:lifterapp/common_widgets/title_row.dart';
import 'package:lifterapp/contants.dart';
import 'package:lifterapp/features/workouts/presentation/list_page_controller.dart';
import 'package:lifterapp/features/workouts/presentation/add_workout_page_controller.dart';
import 'package:lifterapp/features/workouts/presentation/widgets/input_submit_button.dart';
import 'package:lifterapp/features/workouts/presentation/widgets/input_workout_name.dart';
import 'package:lifterapp/features/workouts/presentation/widgets/input_workout_reps.dart';
import 'package:lifterapp/features/workouts/presentation/widgets/input_workout_weigth.dart';
import 'package:lifterapp/features/workouts/presentation/widgets/latest_workout_card.dart';
import 'package:lifterapp/features/workouts/presentation/widgets/resting_time_counter.dart';
import 'package:lifterapp/utils/formatter.dart';

class AddWorkoutPage extends StatelessWidget {
  const AddWorkoutPage({Key? super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TitleRow("Lisää treeni", isHeading: true),
                      RestingTimeCounter(),
                    ],
                  ),
                  InputWorkoutName(),
                  LatestWorkoutCard(),
                  InputWorkoutReps(countOfInputs: 20),
                  InputWorkoutWeigth(),
                ],
              ),
            ),
          ),
        ),
        Container(
          child: InputSubmitButton(),
        )
      ],
    );
  }
}
