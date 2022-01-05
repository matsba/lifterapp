import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:lifterapp/app_state.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MoreMenu extends StatelessWidget {
  const MoreMenu({Key? key}) : super(key: key);

  PopupMenuItem _workoutLogLink(BuildContext context, int value) {
    return PopupMenuItem(
        child: _popUpMenuItemRow(
            text: "Treeniloki",
            icon: Icon(
              Icons.list_alt_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            value: value));
  }

  Widget _moreButton() {
    return StoreConnector<AppState, void Function()>(
        converter: (store) =>
            () => store.dispatch(NavigateToAction.push('/log')),
        builder: (context, navigateToLog) {
          return PopupMenuButton(
              padding: EdgeInsets.all(0),
              onSelected: (result) {
                if (result == 1) {
                  navigateToLog();
                }
              },
              itemBuilder: (context) => [
                    _workoutLogLink(context, 1),
                    _appVersionText(context, 2),
                  ]);
        });
  }

  PopupMenuItem _popUpMenuItemRow(
      {required String text, Icon? icon, required int value}) {
    return PopupMenuItem(
        value: value,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          icon ?? Container(),
          SizedBox(width: 8.0),
          Text(text),
        ]));
  }

  PopupMenuItem _appVersionText(BuildContext context, int value) {
    return PopupMenuItem(
        child: FutureBuilder(
            future: PackageInfo.fromPlatform(),
            builder: (BuildContext context,
                    AsyncSnapshot<PackageInfo> packageInfo) =>
                packageInfo.hasData
                    ? _popUpMenuItemRow(
                        text: packageInfo.data!.version,
                        icon: Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        value: 2)
                    : _popUpMenuItemRow(
                        text: "",
                        value: 2,
                      )));
  }

  @override
  Widget build(BuildContext context) {
    return _moreButton();
  }
}
