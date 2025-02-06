import 'package:flutter/material.dart';
import 'package:inventory_managment/admin/dialogs/edit_item_dialog.dart';
import 'package:inventory_managment/widgets/admin_navigation.dart';
import 'package:inventory_managment/requests/get_items.dart';
import 'package:inventory_managment/admin/dialogs/create_item_dialog.dart';
import 'package:inventory_managment/admin/dialogs/give_item_to_user_dialog.dart';
import 'package:inventory_managment/widgets/page_changer.dart';
import 'package:inventory_managment/widgets/background.dart';
import 'package:inventory_managment/widgets/wrapped_item.dart';
import 'package:inventory_managment/admin/dialogs/delete_item_dialog.dart';
import '../../widgets/status_indicator.dart';
import 'package:inventory_managment/widgets/button.dart';

class StoragePage extends StatefulWidget {
  const StoragePage({super.key});

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  TextEditingController searchController = TextEditingController();
  int currentPage = 1;
  int totalPages = 0;
  String problem = "";
  List<String> users = [];

  Widget getItemWidget(BuildContext context, int itemId, String name,
      String description, int quantity, String status) {
    Widget titleText =
        Text("$name  | $quantityшт.", overflow: TextOverflow.ellipsis);
    return wrappedItem(ListTile(
        title: Row(children: [
          Expanded(child: titleText),
          Row(children: [
            button(
                const Text("Выдать пользователю",
                    style: TextStyle(color: Colors.white)),
                (users.isNotEmpty && quantity != 0)
                    ? () {
                        giveItemToUser(
                            context, itemId, name, quantity, description, users,
                            () {
                          setState(() {});
                        });
                      }
                    : null),
            IconButton(
                onPressed: () {
                  editItemDialog(
                      itemId, name, description, quantity, status, context, () {
                    setState(() {});
                  });
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: (quantity != 0)
                    ? () {
                        deleteItemDialog(itemId, name, quantity, context,
                            () => setState(() {}));
                      }
                    : null,
                icon: const Icon(Icons.delete))
          ]),
        ]),
        subtitle: Row(children: [
          statusIndicator(status),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(description,
                style: const TextStyle(fontSize: 15),
                overflow: TextOverflow.ellipsis),
          ))
        ])));
  }

  void nextPage() {
    setState(() {
      currentPage++;
    });
  }

  void previousPage() {
    setState(() {
      currentPage--;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> data = [];
    return Scaffold(
        body: background(Row(children: [
          adminNavigation(0, context),
          Expanded(
              child: FutureBuilder(
                  future: getItems(currentPage),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else if (snapshot.hasError) {
                      return Text('ошибка: ${snapshot.error}');
                    } else {
                      totalPages = snapshot.data!["totalPages"];
                      users = snapshot.data!["users"].cast<String>();
                      data = snapshot.data!["data"];
                      List<Widget> items = [];
                      for (int i = 0; i < data.length; i++) {
                        items.add(getItemWidget(
                            context,
                            data[i]["id"],
                            data[i]["name"]!,
                            data[i]["description"]!,
                            data[i]["quantity"]!,
                            data[i]["status"]));
                      }
                      if (items.isEmpty) {
                        return const Center(
                            child: Text(
                          "Ничего не найдено :(",
                          style: TextStyle(fontSize: 40),
                        ));
                      }
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                                flex: 7,
                                child: SingleChildScrollView(
                                    child: Column(
                                  children: items,
                                ))),
                            Expanded(
                                flex: 1,
                                child: pageChanger(currentPage, totalPages,
                                    nextPage, previousPage)),
                          ]);
                    }
                  }))
        ])),
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: const Color.fromARGB(180, 255, 240, 245),
            label: const Text(
              "Создать предмет",
              style: TextStyle(
                fontSize: 40,
                color: Colors.black ),
            ),
            icon: const Icon(Icons.add, size: 50),
            onPressed: () {
              showCreateItemDialog(context, () {
                setState(() {});
              });
            }));
  }
}
