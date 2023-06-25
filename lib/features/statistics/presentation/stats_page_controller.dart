import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifterapp/features/statistics/data/statistics_repository.dart';
import 'package:lifterapp/features/statistics/domain/month_workout_volume_statistics.dart';
import 'package:lifterapp/features/statistics/domain/ordinal_workout_volume_statistics.dart';
import 'package:lifterapp/features/workouts/presentation/list_page_controller.dart';
import 'package:lifterapp/services/database_provider.dart';

final yearWorkoutActivityProvider = FutureProvider<List<int>>((ref) async {
  final repository = ref.watch(statisticsRepositoryProvider);
  return await repository.getYearsWeeklyWorkouts();
});

final statisticsRepositoryProvider = Provider<StatisticsRepository>((ref) {
  return StatisticsRepository(db: ref.watch(databaseProvider));
});

final ordinalWorkoutStatisticsProvider =
    FutureProvider.family<OrdinalWorkoutVolumeStatistics, String>(
        (ref, filterName) async {
  final workoutsRepository = ref.watch(workoutsRepositoryProvider);
  final statisticsRepository = ref.watch(statisticsRepositoryProvider);
  final exercises = await workoutsRepository.getAllExercises();
  final volumes =
      await statisticsRepository.getOridnalWorkoutVolumes(filter: filterName);
  var exerciseNames = exercises.map((e) => e.name).toList();
  exerciseNames.add("Kaikki");

  return OrdinalWorkoutVolumeStatistics(
      ordinalWorkoutVolumes: volumes, exerciseNames: exerciseNames);
});

final ordinalWorkoutStatisticsFilterProvider =
    StateProvider<String?>((ref) => "Kaikki");

final monthWorkoutStatisticsProvider =
    FutureProvider<MonthWorkoutVolume>((ref) async {
  final statisticsRepository = ref.watch(statisticsRepositoryProvider);
  return await statisticsRepository.getMonthWorkoutStats();
});
