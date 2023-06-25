import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifterapp/features/settings/data/settings_repository.dart';
import 'package:lifterapp/features/settings/presentation/settings_page.dart';
import 'package:lifterapp/features/settings/presentation/settings_page_controller.dart';
import 'package:lifterapp/services/database_service.dart';
import 'package:sqflite/sqlite_api.dart';

import '../../../test_helpers/database_for_tests.dart';

class MockSettingsRepository implements SettingsRepository {
  @override
  Database get db => throw UnimplementedError();
  bool restingTimeSettingMock = true;

  @override
  Future<bool> getRestingTimeSwitchSetting() async {
    return restingTimeSettingMock;
  }

  @override
  Future<void> saveRestingTimeSwitchSetting(bool switchValue) async {
    restingTimeSettingMock = switchValue;
  }

  @override
  // TODO: implement databaseService
  DatabaseService get databaseService => throw UnimplementedError();

  @override
  Future<Uint8List> getDatabaseFileToExport() {
    // TODO: implement getDatabaseFileToExport
    throw UnimplementedError();
  }

  @override
  Future<void> importDatabaseFile(Uint8List databaseFile) {
    // TODO: implement importDatabaseFile
    throw UnimplementedError();
  }
}

void main() async {
  testWidgets('Settings page has title', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(MockSettingsRepository())
        ],
        child: MaterialApp(home: SettingsPage()),
      ),
    );

    final findPageTitle = find.text("Asetukset");

    expect(findPageTitle, findsOneWidget);
  });

  testWidgets(
      'Settings page displays resting time setting and its off by default',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(MockSettingsRepository())
        ],
        child: MaterialApp(home: SettingsPage()),
      ),
    );

    // Re-render to wait getting data
    await tester.pump();

    final findRestingTimeSettingTitle = find.text("Lepoaika");
    final findSwitchLabel = find.text("Käytä lepoaikaa");
    final Finder switchFinder = find.byKey(const Key('resting_time'));
    final findSwitch = tester.widget<Switch>(switchFinder);

    expect(findSwitch.value, true);
    expect(findRestingTimeSettingTitle, findsOneWidget);
    expect(findSwitchLabel, findsOneWidget);
  });

  testWidgets(
      'Settings page displays resting time setting disabled if it has been set disabled before',
      (tester) async {
    var mock = MockSettingsRepository();
    mock.restingTimeSettingMock = false;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [settingsRepositoryProvider.overrideWithValue(mock)],
        child: MaterialApp(home: SettingsPage()),
      ),
    );

    // Re-render to wait getting data
    await tester.pump();

    final Finder switchFinder = find.byKey(const Key('resting_time'));
    final findSwitch = tester.widget<Switch>(switchFinder);

    expect(findSwitch.value, false);
  });

  testWidgets('Settings page user can switch resting time setting off',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(MockSettingsRepository())
        ],
        child: MaterialApp(home: SettingsPage()),
      ),
    );

    // Re-render to wait getting data
    await tester.pump();

    final Finder switchFinder = find.byKey(const Key('resting_time'));
    await tester.tap(switchFinder);
    // Re-render to wait switch data
    await tester.pump();

    final findSwitch = tester.widget<Switch>(switchFinder);

    expect(findSwitch.value, false);
  });
}
