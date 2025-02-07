import 'package:flutter/material.dart';
import 'package:inventory_managment/admin/pages/item_requests_page.dart';
import 'package:inventory_managment/admin/pages/reports_page.dart';
import 'package:inventory_managment/admin/pages/storage_page.dart';
import 'package:inventory_managment/admin/pages/replacement_requests_page.dart';
import 'package:inventory_managment/admin/pages/inventory_planning_page.dart';
import 'package:inventory_managment/local_storage.dart';
import 'package:inventory_managment/user/pages/authorisation_page.dart';
import 'package:inventory_managment/widgets/background.dart';


void onDestinationSelected(BuildContext context, int index) {
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
      page = const ReportsPage();
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
}

Widget scaffoldWithNavigation(int curPage, BuildContext context, Widget body, [Widget? floatingActionButton]) {
  if (MediaQuery.of(context).size.width < MediaQuery.of(context).size.height) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.storage),
              label: 'Хранилище',
            ),
            NavigationDestination(
              icon: Icon(Icons.cached),
              label: 'Запросы на замену',
            ),
            NavigationDestination(
              icon: Icon(Icons.get_app),
              label: 'Запросы предметов',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_today),
              label: 'Планирование закупок',
            ),
            NavigationDestination(
                icon: Icon(Icons.description), label: 'Отчеты'),
          ],
          selectedIndex: curPage,
          backgroundColor: const Color.fromARGB(0, 0, 0, 0),
          onDestinationSelected: (index) =>
              onDestinationSelected(context, index),
        ),
        body: background(body),
        floatingActionButton: floatingActionButton,
        );
  } else {}
  return Scaffold(
      body: background(Row(children: [
    Column(
      children: [
        Expanded(
          child: NavigationRail(
            selectedIndex: curPage,
            groupAlignment: -1.0,
            backgroundColor: const Color.fromARGB(0, 0, 0, 0),
            selectedLabelTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
            unselectedLabelTextStyle:
                const TextStyle(color: Colors.black, fontSize: 20),
            labelType: NavigationRailLabelType.all,
            onDestinationSelected: (index) =>
                onDestinationSelected(context, index),
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
                icon: Icon(Icons.description),
                label: Text('Отчеты'),
              ),
            ],
          ),
        ),
        const Divider(),
        IconButton(
          icon: const Icon(Icons.logout, size: 40),
          onPressed: () {
            clearUserData();
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    const LoginPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          },
        ),
        const SizedBox(height: 10)
      ],
    ),
    Expanded(child: body)
  ])));
}
