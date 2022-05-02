import 'package:flutter/material.dart'
    show
        BottomNavigationBar,
        BottomNavigationBarItem,
        BuildContext,
        Colors,
        Icon,
        Icons,
        Key,
        StatelessWidget,
        Theme,
        Widget;
import 'package:flutter_redux/flutter_redux.dart' show StoreConnector;
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:lifterapp/app_state.dart' show AppState;
import 'package:redux/redux.dart' show Store;

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) changePage;

  const BottomNavBar(this.selectedIndex, this.changePage, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) {
          return BottomNavigationBar(items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center_sharp),
              label: 'Lisää',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Lista',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Tilastot',
            ),
          ], currentIndex: selectedIndex, onTap: changePage);
        });
  }
}
