import 'package:flutter/widgets.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifterapp/features/settings/presentation/settings_page.dart';
import 'package:lifterapp/features/statistics/presentation/stats_page.dart';
import 'package:lifterapp/features/workouts/presentation/list_page.dart';
import 'package:lifterapp/routing/home_page.dart';
import 'package:riverpod_navigator_core/riverpod_navigator_core.dart';

final _key = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _key,
    debugLogDiagnostics: true,
    initialLocation: HomePage.routeLocation,
    routes: [
      GoRoute(
        path: HomePage.routeLocation,
        name: HomePage.routeName,
        builder: (context, state) {
          return HomePage();
        },
      ),
      GoRoute(
        path: ListPage.routeLocation,
        name: ListPage.routeName,
        builder: (context, state) {
          return ListPage();
        },
      ),
      GoRoute(
        path: StatsPage.routeLocation,
        name: StatsPage.routeName,
        builder: (context, state) {
          return const StatsPage();
        },
      ),
      GoRoute(
        path: SettingsPage.routeLocation,
        name: SettingsPage.routeName,
        builder: (context, state) {
          return SettingsPage();
        },
      ),
    ],
/*     redirect: (context, state) {
      // If our async state is loading, don't perform redirects, yet
    }, */
  );
});
