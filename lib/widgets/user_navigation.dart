import 'package:flutter/material.dart';
import 'package:inventory_managment/user/pages/item_requests_page.dart';
import 'package:inventory_managment/user/pages/replacements_requests_page.dart';
import 'package:inventory_managment/user/pages/user_storage_page.dart';

Widget userNavigation(
  int curPage,
  BuildContext context,
) {
  return NavigationRail(
    backgroundColor: Colors.transparent,
    selectedIndex: curPage,
    groupAlignment: -1.0,
    onDestinationSelected: (int index) {
      Widget? page;
      switch (index) {
        case 0:
          page = const UserStoragePage();
        case 1:
          page = const ItemRequestsPage();
        case 2:
          page = const ReplacementRequestsPage();
      }
      if (page != null) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => page!,
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }
    },
    labelType: NavigationRailLabelType.all,
    destinations: const <NavigationRailDestination>[
      NavigationRailDestination(
        icon: Icon(Icons.list_alt),
        label: Text('Предметы'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.send),
        label: Text('Запросить предметы'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.handyman),
        label: Text('Запросить замену'),
      ),
    ],
  );
}
