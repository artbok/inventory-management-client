import 'package:flutter/material.dart';
import 'package:inventory_managment/admin/pages/item_requests_page.dart';
import 'package:inventory_managment/admin/pages/storage_page.dart';
import 'package:inventory_managment/admin/pages/replacement_requests_page.dart';
import 'package:inventory_managment/admin/pages/inventory_planning_page.dart';

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
    unselectedLabelTextStyle: const TextStyle(
        color: Color.fromARGB(255, 243, 175, 150), fontSize: 20),
    onDestinationSelected: (int index) {
      Widget? page;
      switch (index) {
        case 0:
          page = const StoragePage();
        case 1:
          page = const ReplacementRequestsPage();
        case 2:
          page = const ItemRequestsPage();
        case 3:
          page = const InventoryPlanningPage();
        case 4:
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
        icon: Icon(Icons.calendar_today),
        label: Text('Планирование закупок'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.query_stats),
        label: Text('Статистика'),
      ),
    ],
  );
}
