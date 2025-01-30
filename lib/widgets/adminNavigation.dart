import 'package:flutter/material.dart';
import '../pages/admin/itemsRequestsPage.dart';
import '../pages/admin/storagePage.dart';
import '../pages/admin/replacementsRequestsPage.dart';

Widget adminNavigation(
  int curPage,
  BuildContext context,
) {
  return NavigationRail(
    selectedIndex: curPage,
    groupAlignment: -1.0,
    backgroundColor: const Color.fromARGB(0, 0, 0, 0),
    selectedLabelTextStyle: const TextStyle(
      color: Color.fromARGB(255, 243, 175, 150),
      fontSize: 20,
      
      
    ),
    unselectedLabelTextStyle: const TextStyle(color: Color.fromARGB(255, 243, 175, 150), fontSize: 20),
    onDestinationSelected: (int index) {
      Widget? page;
      switch (index) {
        case 0:
          page = const StoragePage();
        case 1:
          page = const ReplacementsRequestsPage();
        case 2:
          page = const ItemsRequestsPage();
        case 3:
          //page = const Statspage();
          print("шнип шнап шнапи");

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
        label: Text('Хранилище'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.cached),
        label: Text('Запросы на замену'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.get_app),
        label: Text('Запросы предметов'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.query_stats),
        label: Text('Статистика'),
      ),
    ],
  );
}
