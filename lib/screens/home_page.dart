import 'package:flutter/material.dart';
import 'package:lifterapp/components/app_scaffold.dart';
import 'package:lifterapp/containers/bottom_navigationbar.dart';
import 'package:lifterapp/screens/add_workout_page.dart';
import 'package:lifterapp/screens/list_page.dart';
import 'package:lifterapp/screens/stats_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [AddWorkoutPage(), ListPage(), StatsPage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        bodyContent: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        navbar: BottomNavBar(_selectedIndex, _onItemTapped));
  }
}
