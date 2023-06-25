import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifterapp/routing/navigation_service.dart';
import 'package:lifterapp/theme.dart';

class App extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        routeInformationProvider: router.routeInformationProvider,
        theme: GlobalTheme().globalTheme);
  }
}


/*     return MaterialApp(
        navigatorKey: NavigatorHolder.navigatorKey,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          // Manage your route names here
          switch (NavigationLink.fromString(settings.name ?? "")) {
            case NavigationLink.home:
              builder = (BuildContext context) => HomePage();
              break;
            case NavigationLink.list:
              builder = (BuildContext context) => ListPage();
              break;
/*             case NavigationLink.log:
              builder = (BuildContext context) => LogPage();
              break;
            case NavigationLink.stats:
              builder = (BuildContext context) => StatsPage();
              break;
            case NavigationLink.settings:
              builder = (BuildContext context) => SettingsPage();
              break; */
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
        theme: GlobalTheme().globalTheme); */