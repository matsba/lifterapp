import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifterapp/common_widgets/app_scaffold.dart';
import 'package:lifterapp/features/workouts/presentation/list_page.dart';
import 'package:lifterapp/routing/bottom_navigationbar.dart';
import 'package:lifterapp/routing/selected_page_provider.dart';

class HomePage extends ConsumerWidget {
  static String get routeName => 'home';
  static String get routeLocation => '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedIndex = ref.watch(selectedBottomoNavigationIndexProvicer);
    var pages = ref.watch(bottomNavigationPagesProvider);
    return AppScaffold(
        bodyContent: IndexedStack(
          index: selectedIndex,
          children: pages,
        ),
        navbar: BottomNavBar(
            selectedIndex,
            (int index) => ref
                .read(selectedBottomoNavigationIndexProvicer.notifier)
                .state = index));
  }
}
