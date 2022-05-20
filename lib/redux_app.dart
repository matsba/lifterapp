import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:lifterapp/screens/settings_page.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:lifterapp/middleware/app_middleware.dart';
import 'package:lifterapp/models/app_state.dart';
import 'package:lifterapp/screens/home_page.dart';
import 'package:lifterapp/screens/list_page.dart';
import 'package:lifterapp/screens/log_page.dart';
import 'package:lifterapp/screens/stats_page.dart';
import 'package:lifterapp/theme.dart';

class ReduxApp extends StatelessWidget {
  final Store<AppState> store;

  ReduxApp({
    Key? key,
    required this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    store.dispatch(getLatestWorkoutGroup());
    store.dispatch(getWorkoutCards());
    store.dispatch(getWorkoutLog());
    store.dispatch(getOrdinalWorkoutVolumes("Kaikki"));
    store.dispatch(getWorkoutVolumeStatistics());
    store.dispatch(getYearWorkoutActivity());
    store.dispatch(getSettings());
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
          navigatorKey: NavigatorHolder.navigatorKey,
          initialRoute: '/',
          onGenerateRoute: (RouteSettings settings) {
            WidgetBuilder builder;
            // Manage your route names here
            switch (settings.name) {
              case '/':
                builder = (BuildContext context) => const HomePage();
                break;
              case '/list':
                builder = (BuildContext context) => ListPage();
                break;
              case '/log':
                builder = (BuildContext context) => LogPage();
                break;
              case '/stats':
                builder = (BuildContext context) => const StatsPage();
                break;
              case '/settings':
                builder = (BuildContext context) => SettingsPage();
                break;
              default:
                throw Exception('Invalid route: ${settings.name}');
            }
            // You can also return a PageRouteBuilder and
            // define custom transitions between pages
            return MaterialPageRoute(
              builder: builder,
              settings: settings,
            );
          },
          theme: GlobalTheme().globalTheme),
    );
  }
}
