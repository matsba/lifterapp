import 'package:flutter/material.dart';

@immutable
class SettingsState {
  final bool usingRestingTime;
  final int restingTimeInSeconds;

  SettingsState(
      {required this.usingRestingTime, required this.restingTimeInSeconds});

  SettingsState.initial()
      : usingRestingTime = false,
        restingTimeInSeconds = 90;

  copyWith({bool? usingRestingTime, int? restingTimeInSeconds}) =>
      SettingsState(
          usingRestingTime: usingRestingTime ?? this.usingRestingTime,
          restingTimeInSeconds:
              restingTimeInSeconds ?? this.restingTimeInSeconds);
}
