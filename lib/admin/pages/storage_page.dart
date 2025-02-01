import 'package:flutter/material.dart';
import 'package:inventory_managment/admin/dialogs/edit_item_dialog.dart';
import 'package:inventory_managment/widgets/admin_navigation.dart';
import 'package:inventory_managment/requests/get_items.dart';
import 'package:inventory_managment/admin/dialogs/create_item_dialog.dart';
import 'package:inventory_managment/admin/dialogs/give_item_to_user_dialog.dart';
import 'package:inventory_managment/widgets/page_changer.dart';
import 'package:inventory_managment/widgets/background.dart';
import 'package:inventory_managment/widgets/wrapped_item.dart';

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

  Widget getItemWidget(int itemId, String name, String description,
      int quantity, int quantityInStorage, String status) {
    Widget titleText = Text(
        "$name  Доступно: $quantityInStorageшт.  Всего: $quantityшт.",
        overflow: TextOverflow.ellipsis);
    return wrappedItem(ListTile(
        title: (users.isNotEmpty && quantityInStorage != 0)
            ? Row(children: [
                titleText,
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return giveItemToUser(itemId, name,
                                quantityInStorage, description, users, () {
                              setState(() {});
                            });
                          });
                    },
                    child: const Text("Выдать пользователю")),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return editItemDialog(
                                itemId,
                                name,
                                description,
                                quantity,
                                quantity - quantityInStorage,
                                status,
                                context, () {
                              setState(() {});
                            });
                          });
                    },
                    icon: const Icon(Icons.edit))
              ])
            : titleText,
        subtitle: Text(description,
            style: const TextStyle(fontSize: 15),
            overflow: TextOverflow.ellipsis)));
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
        appBar: AppBar(
          title: Row(
            children: [
              const Expanded(flex: 2, child: Text("Хранилище")),
              Expanded(flex: 2, child: Container()),
              Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "поиск",
                        style: TextStyle(fontSize: 16),
                      ),
                      Container(
                          color: Colors.white,
                          child: TextFormField(controller: searchController)),
                    ],
                  )),
              Expanded(flex: 1, child: Container()),
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 235, 205, 197),
        ),
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
                            data[i]["id"],
                            data[i]["name"]!,
                            data[i]["description"]!,
                            data[i]["quantity"]!,
                            data[i]["quantityInStorage"]!,
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
            label: const Text(
              "Создать предмет",
              style: TextStyle(fontSize: 40),
            ),
            icon: const Icon(Icons.add, size: 50),
            onPressed: () {
              showCreateItemDialog(context, () {
                setState(() {});
              });
            }));
  }
}
