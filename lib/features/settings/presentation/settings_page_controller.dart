import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifterapp/features/settings/data/settings_repository.dart';
import 'package:lifterapp/features/statistics/presentation/stats_page_controller.dart';
import 'package:lifterapp/features/workouts/presentation/add_workout_page_controller.dart';
import 'package:lifterapp/features/workouts/presentation/list_page_controller.dart';
import 'package:lifterapp/services/database_provider.dart';
import 'package:lifterapp/services/database_service.dart';

final usingRestingTimeFeatureProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(settingsRepositoryProvider);
  return repository.getRestingTimeSwitchSetting();
});

final updateUsingRestingTimeFeatureProvider =
    FutureProvider.autoDispose.family<void, bool>((ref, switchValue) async {
  final repository = ref.watch(settingsRepositoryProvider);
  await repository.saveRestingTimeSwitchSetting(switchValue);
  ref.refresh(usingRestingTimeFeatureProvider);
});

final databaseExportProvider = FutureProvider<Uint8List>((ref) async {
  final repository = ref.watch(settingsRepositoryProvider);
  return await repository.getDatabaseFileToExport();
});

final databaseImportProvider =
    FutureProvider.family.autoDispose<void, Uint8List>((ref, data) async {
  final repository = ref.watch(settingsRepositoryProvider);
  print("Importing database...");
  ref.watch(databaseProvider);
  //print("Refressing database provider...");
  ref.refresh(databaseServiceProvider);
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(
      db: ref.watch(databaseProvider),
      databaseService: ref.watch(databaseServiceProvider));
});
