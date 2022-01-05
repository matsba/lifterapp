import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:lifterapp/app_state.dart';
import 'package:lifterapp/components/bottom_navigationbar.dart';
import 'package:lifterapp/components/more_menu.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppScaffold extends StatelessWidget {
  final Widget bodyContent;
  final BottomNavBar? navbar;

  const AppScaffold({required this.bodyContent, this.navbar, Key? key})
      : super(key: key);

  AppBar _appBar() {
    return AppBar(
      title: Row(
        children: [
          Image.asset(
            "lib/assets/logo-512.png",
            scale: 12,
          ),
          const SizedBox(
            width: 10,
          ),
          const Text('Lifter.app'),
        ],
      ),
      actions: [const MoreMenu()],
    );
  }

  Widget _scaffoldWithNavbar() {
    return Scaffold(
      appBar: _appBar(),
      body: bodyContent,
      bottomNavigationBar: navbar,
    );
  }

  Widget _scaffoldWithoutNavbar() {
    return Scaffold(
      appBar: _appBar(),
      body: bodyContent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child:
            navbar != null ? _scaffoldWithNavbar() : _scaffoldWithoutNavbar());
  }
}
