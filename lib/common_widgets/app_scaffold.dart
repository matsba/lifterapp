import 'package:flutter/material.dart';
import 'package:lifterapp/common_widgets/more_menu.dart';
import 'package:lifterapp/routing/bottom_navigationbar.dart';

class AppScaffold extends StatelessWidget {
  final Widget bodyContent;
  final BottomNavBar? navbar;

  const AppScaffold({required this.bodyContent, this.navbar, Key? super.key});

  AppBar _appBar() {
    return AppBar(
      title: Row(
        children: [
          Image.asset(
            "assets/logo-512.png",
            scale: 12,
          ),
          const SizedBox(
            width: 10,
          ),
          const Text('Lifter.app'),
        ],
      ),
      actions: const [MoreMenu()],
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
