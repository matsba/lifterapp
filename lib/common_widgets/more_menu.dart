import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifterapp/routing/navigation_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MoreMenu extends ConsumerWidget {
  const MoreMenu({Key? super.key});

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
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
        padding: EdgeInsets.all(0),
        onSelected: (result) async {
          switch (result) {
            case 1:
              ref.read(routerProvider).push("/log");
              break;
            case 2:
              showLicensePage(context: context);
              break;
            case 3:
              await launchUrlString(
                  "https://github.com/matsba/lifterapp/releases");
              break;
            case 4:
              ref.read(routerProvider).push("/settings");
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
  }
}
