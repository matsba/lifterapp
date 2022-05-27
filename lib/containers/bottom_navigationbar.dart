import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:lifterapp/models/app_state.dart';
import 'package:redux/redux.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) changePage;

  const BottomNavBar(this.selectedIndex, this.changePage, {Key? super.key});

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
