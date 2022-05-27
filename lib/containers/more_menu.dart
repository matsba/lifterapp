import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:lifterapp/models/app_state.dart';
import 'package:lifterapp/services/navigation_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MoreMenu extends StatelessWidget {
  const MoreMenu({Key? super.key});

  Widget _moreButton() {
    return StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromStore(store),
        builder: (context, vm) {
          return PopupMenuButton(
              padding: EdgeInsets.all(0),
              onSelected: (result) async {
                switch (result) {
                  case 1:
                    vm.navigateTo(NavigationLink.log);
                    break;
                  case 2:
                    showLicensePage(context: context);
                    break;
                  case 3:
                    await launchUrlString(
                        "https://github.com/matsba/lifterapp/releases");
                    break;
                  case 4:
                    vm.navigateTo(NavigationLink.settings);
                    break;
                  default:
                }
              },
              itemBuilder: (context) => [
                    _workoutLogLink(context),
                    _settingsLink(context),
                    _menuDivider(),
                    _appLicensesLink(context),
                    _appVersionText(context),
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

  PopupMenuItem _menuDivider() {
    return const PopupMenuItem(
      child: Divider(
        thickness: 1.5,
      ),
      height: 6,
    );
  }

  PopupMenuItem _workoutLogLink(BuildContext context) {
    return PopupMenuItem(
        child: _popUpMenuItemRow(
            text: "Treeniloki",
            icon: Icon(
              Icons.list_alt_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            value: 1));
  }

  PopupMenuItem _settingsLink(BuildContext context) {
    return PopupMenuItem(
        child: _popUpMenuItemRow(
            text: "Asetukset",
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.primary,
            ),
            value: 4));
  }

  PopupMenuItem _appVersionText(BuildContext context) {
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
                        value: 3)
                    : _popUpMenuItemRow(
                        text: "",
                        value: 3,
                      )));
  }

  PopupMenuItem _appLicensesLink(BuildContext context) {
    return PopupMenuItem(
        child: _popUpMenuItemRow(
            text: "Lisenssit",
            icon: Icon(
              Icons.copyright,
              color: Theme.of(context).colorScheme.primary,
            ),
            value: 2));
  }

  @override
  Widget build(BuildContext context) {
    return _moreButton();
  }
}

class _ViewModel {
  final Function(NavigationLink) navigateTo;

  _ViewModel({required this.navigateTo});

  static fromStore(Store<AppState> store) => _ViewModel(
      navigateTo: (NavigationLink link) =>
          store.dispatch(NavigationService().to(link)));
}
