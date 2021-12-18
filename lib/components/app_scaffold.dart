import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:lifterapp/app_state.dart';
import 'package:lifterapp/components/bottom_navigationbar.dart';

class AppScaffold extends StatelessWidget {
  final List<Widget> bodyContent;
  final int? navBarIndex;
  final bool? showNavbar;

  const AppScaffold(
      {required this.bodyContent,
      this.navBarIndex,
      this.showNavbar = true,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lifter-app'),
        actions: [_moreButton()],
      ),
      body: Container(
        child: Column(children: bodyContent),
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      ),
      bottomNavigationBar:
          (showNavbar! ? BottomNavBar(navBarIndex ?? 0) : Container()),
    );
  }
}
