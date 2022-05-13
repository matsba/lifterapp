import 'package:flutter/material.dart';
import 'package:lifterapp/containers/input_submit_button.dart';
import 'package:lifterapp/containers/input_workout_name.dart';
import 'package:lifterapp/containers/input_workout_reps.dart';
import 'package:lifterapp/containers/input_workout_weigth.dart';
import 'package:lifterapp/components/title_row.dart';

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
                  TitleRow("Lisää treeni", isHeading: true),
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
