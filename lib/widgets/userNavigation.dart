import 'package:flutter/material.dart';
import '../pages/user/userRequestsPage.dart';
import '../pages/user/replacementsRequestsPage.dart';
import '../pages/user/userStoragePage.dart';



Widget userNavigation(
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
          page = const UserStoragePage();
        case 1:
          page = const UserRequestsPage();
        case 2:
          page = const ReplacementsRequestsPage();
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
        label: Text('Inventory'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.send),
        label: Text('Request Item'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.handyman),
        label: Text('Request Repairment'),
      ),
    ],
  );
}
