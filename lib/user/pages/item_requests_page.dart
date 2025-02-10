import 'package:flutter/material.dart';
import 'package:inventory_managment/widgets/user_navigation.dart';
import 'package:inventory_managment/local_storage.dart';
import 'package:inventory_managment/requests/get_items_requests.dart';
import 'package:inventory_managment/user/pages/request_storage_item_page.dart';
import 'package:inventory_managment/user/dialogs/request_custom_item_dialog.dart';
import 'package:inventory_managment/widgets/wrapped_item.dart';
import 'package:inventory_managment/widgets/request_status_indicator.dart';
import 'package:inventory_managment/widgets/button.dart';

class ItemRequestsPage extends StatefulWidget {
  const ItemRequestsPage({super.key});

  @override
  State<ItemRequestsPage> createState() => ItemRequestsPageState();
}

class ItemRequestsPageState extends State<ItemRequestsPage> {
  TextEditingController searchController = TextEditingController();

  Widget getItemWidget(int id, String name, String description, String status,
      int quantity, String owner) {
    return wrappedItem(ListTile(
        title: Text("$name     ${quantity}x"),
        subtitle: Row(children: [
          requestStatusIndicator(status),
          Expanded(child: Container())
        ])));
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> data = [];
    String owner = getValue("username");
    return scaffoldWithUserNavigation(
        1,
        context,
        FutureBuilder(
            future: getItemsRequests(
              owner,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Ошибка: ${snapshot.error}');
              } else {
                data = snapshot.data!["data"];
                List<Widget> items = [];
                for (int i = 0; i < data.length; i++) {
                  items.add(getItemWidget(
                    data[i]["id"],
                    data[i]["name"]!,
                    data[i]["description"],
                    data[i]["status"],
                    data[i]["quantity"]!,
                    data[i]["owner"],
                  ));
                }
                return Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                          button(
                                const Text(
                                      "Заказать кастомный предмет", style: TextStyle(color: Colors.black),),
                                  () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return requestCustomItemDialog(
                                              context, () {
                                            setState(() {});
                                          });
                                        });
                                  },
                                  ),
                          button(
                                const Text(
                                      "Заказать предмет со склада",
                                    style: TextStyle(color: Colors.black)),
                                  () {
                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                const RequestStorageItemPage(),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero,
                                      ),
                                    );
                                  },
                                  ),
                        ])),
                    Expanded(
                        flex: 6,
                        child: SingleChildScrollView(
                            child: Column(
                          children: items,
                        ))),
                    Expanded(flex: 1, child: Container())
                  ],
                );
              }
            }));
  }
}
