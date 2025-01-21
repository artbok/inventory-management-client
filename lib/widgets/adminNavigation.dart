import 'package:flutter/material.dart';
import '../pages/user/replacementsRequestsPage.dart';
import '../pages/user/userRequestsPage.dart';
import '../pages/admin/storagePage.dart';

Widget adminNavigation(
  int curPage,
  BuildContext context,
) {
  return NavigationRail(
    selectedIndex: curPage,
    groupAlignment: -1.0,
    onDestinationSelected: (int index) {
      Widget? page;
      switch (index) {
        case 0:
          page = const StoragePage();
        case 1:
          page = const ReplacementsRequestsPage();
        case 2:
          page = const UserRequestsPage();
        case 3:
          print("Шнип шнап шнапи");
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
        icon: Icon(Icons.storage),
        label: Text('Storage'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.cached),
        label: Text('Replace Requests'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.get_app),
        label: Text('Items Requests'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.query_stats),
        label: Text('Stats'),
      ),
    ],
  );
}
