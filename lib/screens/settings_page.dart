import 'package:flutter/material.dart';
import 'package:lifterapp/components/app_scaffold.dart';
import 'package:lifterapp/components/title_row.dart';
import 'package:lifterapp/containers/resting_time_setting.dart';

class SettingsPage extends StatelessWidget {
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
