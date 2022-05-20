import 'package:flutter/material.dart';
import 'package:lifterapp/containers/input_submit_button.dart';
import 'package:lifterapp/containers/input_workout_name.dart';
import 'package:lifterapp/containers/input_workout_reps.dart';
import 'package:lifterapp/containers/input_workout_weigth.dart';
import 'package:lifterapp/components/title_row.dart';
import 'package:lifterapp/containers/resting_time_counter.dart';

class AddWorkoutPage extends StatelessWidget {
  const AddWorkoutPage({Key? key}) : super(key: key);

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
