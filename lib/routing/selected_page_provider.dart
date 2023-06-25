import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifterapp/features/statistics/presentation/stats_page.dart';
import 'package:lifterapp/features/workouts/presentation/add_workout_page.dart';
import 'package:lifterapp/features/workouts/presentation/list_page.dart';

final selectedBottomoNavigationIndexProvicer = StateProvider<int>((ref) => 0);

final bottomNavigationPagesProvider = StateProvider<List<Widget>>(
    ((ref) => [AddWorkoutPage(), ListPage(), StatsPage()]));
