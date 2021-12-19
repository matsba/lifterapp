import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:lifterapp/app_state.dart';
import 'package:lifterapp/components/bottom_navigationbar.dart';

class AppScaffold extends StatelessWidget {
  final List<Widget> bodyContent;
  final int? navBarIndex;
  final bool? showNavbar;
  final bool? expanded;
  final _padding = const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0);

  const AppScaffold(
      {required this.bodyContent,
      this.navBarIndex,
      this.showNavbar = true,
      this.expanded = false,
      Key? key})
      : super(key: key);

  PopupMenuItem _workoutLogLink({iconColor, link}) {
    return PopupMenuItem(
        child: GestureDetector(
      onTap: () => link(),
      child: Row(
        children: [
          Icon(
            Icons.list_alt_outlined,
            color: iconColor,
          ),
          const Text("Treeniloki"),
        ],
      ),
    ));
  }

  Widget _moreButton() {
    return StoreConnector<AppState, void Function()>(
        converter: (store) =>
            () => store.dispatch(NavigateToAction.replace('/log')),
        builder: (context, navigateToLog) {
          return PopupMenuButton(
              itemBuilder: (context) => [
                    _workoutLogLink(
                        iconColor: Theme.of(context).colorScheme.primary,
                        link: navigateToLog)
                  ]);
        });
  }

  Widget _expandedContainer() {
    return Flex(direction: Axis.vertical, children: [
      Expanded(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: bodyContent),
        padding: _padding,
      ))
    ]);
  }

  Widget _staticContainer() {
    return Container(
      child: Column(children: bodyContent),
      padding: _padding,
    );
  }

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
      actions: [_moreButton()],
    );
  }

  Widget _scaffoldWithNavbar() {
    return Scaffold(
      appBar: _appBar(),
      body: expanded! ? _expandedContainer() : _staticContainer(),
      bottomNavigationBar: BottomNavBar(navBarIndex ?? 0),
    );
  }

  Widget _scaffoldWithoutNavbar() {
    return Scaffold(
      appBar: _appBar(),
      body: expanded! ? _expandedContainer() : _staticContainer(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return showNavbar! ? _scaffoldWithNavbar() : _scaffoldWithoutNavbar();
  }
}
