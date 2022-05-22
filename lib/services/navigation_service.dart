import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';

class NavigationService {
  to(NavigationLink link) => NavigateToAction.push(link.toString());

  NavigationService();
}

enum NavigationLink {
  home("/"),
  list("/list"),
  log("/log"),
  stats("/stats"),
  settings("/settings");

  @override
  String toString() => link;

  static NavigationLink fromString(String value) => NavigationLink.values
      .firstWhere((element) => element.toString() == value);

  final String link;
  const NavigationLink(this.link);
}
