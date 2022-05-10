import 'package:flutter/material.dart';
import 'package:lifterapp/containers/workout_log.dart';
import 'package:lifterapp/components/app_scaffold.dart';

class LogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bodyContent: WorkoutLog(),
    );
  }
}
