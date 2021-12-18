import 'package:flutter/material.dart' hide NavigationDestination;
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:lifterapp/app_middleware.dart'
    show getLatestWorkoutGroup, getWorkoutCards, getWorkoutLog;
import 'package:lifterapp/app_reducer.dart';
import 'package:lifterapp/app_state.dart' show AppState;
import 'package:lifterapp/screens/home_page.dart' show HomePage;
import 'package:lifterapp/screens/list_page.dart' show ListPage;
import "package:flutter_redux/flutter_redux.dart" show StoreProvider;
import 'package:lifterapp/screens/log_page.dart';
import 'package:lifterapp/theme.dart';
import 'package:redux/redux.dart' show Store, combineReducers;
import 'package:redux_thunk/redux_thunk.dart' show thunkMiddleware;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // final store = Store<AppState>(reducer,
  //     initialState: AppState.initialState(), middleware: [thunkMiddleware]);
  final store = Store<AppState>(reducer,
      initialState: AppState.initialState(),
      middleware: [const NavigationMiddleware(), thunkMiddleware]);

  @override
  Widget build(BuildContext context) {
    store.dispatch(getLatestWorkoutGroup());
    store.dispatch(getWorkoutCards());
    store.dispatch(getWorkoutLog());
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
                builder = (BuildContext context) => HomePage();
                break;
              case '/list':
                builder = (BuildContext context) => ListPage();
                break;
              case '/log':
                builder = (BuildContext context) => LogPage();
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
