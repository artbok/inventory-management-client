import 'package:flutter/material.dart';
import 'package:inventory_managment/user/pages/item_requests_page.dart';
import 'package:inventory_managment/user/pages/replacements_requests_page.dart';
import 'package:inventory_managment/user/pages/user_storage_page.dart';
import 'package:inventory_managment/widgets/background.dart';
import 'package:inventory_managment/local_storage.dart';
import 'package:inventory_managment/user/pages/authorisation_page.dart';

void _onDestinationSelected(BuildContext context, int index) {
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
}

Widget scaffoldWithUserNavigation(
    int curPage, BuildContext context, Widget body) {
  if (MediaQuery.of(context).size.width < MediaQuery.of(context).size.height) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.list_alt),
            label: 'Предметы',
          ),
          NavigationDestination(
            icon: Icon(Icons.send),
            label: 'Запросить предметы',
          ),
          NavigationDestination(
            icon: Icon(Icons.handyman),
            label: 'Запросить замену',
          ),
        ],
        selectedIndex: curPage,
        backgroundColor: const Color.fromARGB(255, 254, 221, 220),
        indicatorColor: const Color.fromARGB(255, 233, 141, 133),
        onDestinationSelected: (index) =>
            _onDestinationSelected(context, index),
      ),
      body: 
      background(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        IconButton(
          icon: const Icon(Icons.logout, size: 20),
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
        Expanded(child: body)
      ],))
    );
  }
  return Scaffold(
      body: background(Row(children: [
    Column(
      children: [
        Expanded(
          child: NavigationRail(
            selectedIndex: curPage,
            groupAlignment: -1.0,
            backgroundColor: const Color.fromARGB(0, 0, 0, 0),
            indicatorColor: const Color.fromARGB(255, 233, 141, 133),
            selectedLabelTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
            unselectedLabelTextStyle:
                const TextStyle(color: Colors.black, fontSize: 20),
            labelType: NavigationRailLabelType.all,
            onDestinationSelected: (index) =>
                _onDestinationSelected(context, index),
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
