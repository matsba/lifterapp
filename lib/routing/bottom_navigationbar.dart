import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) changePage;

  const BottomNavBar(this.selectedIndex, this.changePage, {Key? super.key});

  @override
  Widget build(BuildContext context) {
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
  }
}
