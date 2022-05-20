import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:lifterapp/actions/app_actions.dart';
import 'package:lifterapp/middleware/app_middleware.dart';
import 'package:lifterapp/models/app_state.dart';
import 'package:redux/redux.dart';

class RestingTimeCounter extends StatefulWidget {
  @override
  State<RestingTimeCounter> createState() => _RestingTimeCounterState();
}

class _RestingTimeCounterState extends State<RestingTimeCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 0));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromStore(store),
        builder: (context, vm) {
          if (vm.restingTime == null) {
            return const SizedBox();
          }
          _controller.duration = vm.restingTime;
          _controller.forward();

          var tween = StepTween(
            begin: 1 + vm.restingTime!.inSeconds,
            end: 0,
          ).animate(_controller);

          tween.addListener(() {
            if (_controller.lastElapsedDuration != null &&
                _controller.duration != null) {
              print(
                  "Time elapsed ${_controller.lastElapsedDuration!} with status ${tween.status}");

              var startTime = DateTime.now().subtract((_controller.duration!));
              var currentTime = DateTime.now();
              var difference = startTime.difference(currentTime);

              if (difference.inSeconds + 1 > _controller.duration!.inSeconds) {
                print(
                    "startTime $startTime, _controller.lastElapsedDuration ${_controller.lastElapsedDuration} currentTime $currentTime --- $difference");
                print(
                    "There was a difference in time! ${difference.inSeconds}");
                _controller.duration = difference;
                _controller.forward();
              }
            }
          });

          tween.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              vm.resetRestingTime();
              _controller.reset();
            }
          });

          return GestureDetector(
            onLongPress: () {
              vm.cancelRestingTimer();
              _controller.reset();
            },
            child: Countdown(
              animation: tween,
            ),
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
  final void Function() resetRestingTime;
  final void Function() cancelRestingTimer;

  _ViewModel(
      {required this.restingTime,
      required this.resetRestingTime,
      required this.cancelRestingTimer});

  static fromStore(Store<AppState> store) => _ViewModel(
        restingTime: store.state.addWorkoutState.restingTime,
        resetRestingTime: () => store.dispatch(ResetRestingTimeAction()),
        cancelRestingTimer: () => store.dispatch(cancelRestingTime()),
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
        width: 75,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(75)),
            color: Theme.of(context).colorScheme.secondary,
            boxShadow: [
              const BoxShadow(color: Colors.black, offset: Offset(0.5, 1))
            ]),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.hourglass_top),
                Text(
                  timerText,
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            )));
  }
}
