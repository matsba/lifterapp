import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:lifterapp/models/app_state.dart';
import 'package:redux/redux.dart';

class RestingTimeCounter extends StatefulWidget {
  @override
  State<RestingTimeCounter> createState() => _RestingTimeCounterState();
}

class _RestingTimeCounterState extends State<RestingTimeCounter>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromStore(store),
        builder: (context, vm) {
          if (vm.restingTime == null) {
            return SizedBox();
          }
          _controller.duration = vm.restingTime;
          _controller.forward();

          final tween = StepTween(
            begin: vm.restingTime?.inSeconds,
            end: 0,
          ).animate(_controller);

          tween.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _controller.dispose();
            }
          });

          return Countdown(
            animation: tween,
          );
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _ViewModel {
  final Duration? restingTime;

  _ViewModel({required this.restingTime});

  static fromStore(Store<AppState> store) => _ViewModel(
        restingTime: store.state.addWorkoutState.restingTime,
      );
}

class Countdown extends AnimatedWidget {
  Countdown({required this.animation}) : super(listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${(clockTimer.inSeconds.remainder(60) % 60).toString().padLeft(2, '0')}';

    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(75)), //here
            color: Theme.of(context).colorScheme.secondary,
            boxShadow: [
              BoxShadow(color: Colors.black, offset: Offset(0.5, 1))
            ]),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.hourglass_top),
                Text(
                  "$timerText",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            )));
  }
}
