import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifterapp/features/workouts/data/workouts_repository.dart';
import 'package:lifterapp/features/workouts/domain/session.dart';
import 'package:lifterapp/features/workouts/domain/training.dart';
import 'package:lifterapp/services/database_provider.dart';

final sessionListProvider =
    FutureProvider.autoDispose<List<Session>>((ref) async {
  final workoutsRepository = ref.watch(workoutsRepositoryProvider);
  final training = await workoutsRepository.getTraining(1);
  if (training == null) {
    return [];
  }
  return training.sessions;
});

final workoutsRepositoryProvider = Provider<WorkoutsRepository>((ref) {
  return WorkoutsRepository(db: ref.watch(databaseProvider));
});
