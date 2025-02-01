import 'package:flutter/material.dart';
import 'package:inventory_managment/widgets/admin_navigation.dart';
import 'package:inventory_managment/requests/get_plans.dart';
import 'package:inventory_managment/admin/dialogs/create_item_dialog.dart';
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

  Widget getPlanWidget(int id, String itemName, String itemDescription,
      int itemQuantity, int price, String supplier, bool completed) {
    return wrappedItem(
        Text("$itemName  $itemQuantity. $price€",
            overflow: TextOverflow.ellipsis),
        Text("$supplier | $itemDescription",
            style: const TextStyle(fontSize: 15),
            overflow: TextOverflow.ellipsis));
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
              const Expanded(flex: 2, child: Text("Планирование закупок")),
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
                  future: getPlans(currentPage),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else if (snapshot.hasError) {
                      return Text('ошибка: ${snapshot.error}');
                    } else {
                      totalPages = snapshot.data!["totalPages"];
                      data = snapshot.data!["data"];
                      List<Widget> items = [];
                      for (int i = 0; i < data.length; i++) {
                        items.add(getPlanWidget(
                            data[i]["id"],
                            data[i]["itemName"]!,
                            data[i]["itemDescription"]!,
                            data[i]["itemQuantity"]!,
                            data[i]["supplier"]!,
                            data[i]["price"],
                            data[i]["completed"]));
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
              "Добавить закупку",
              style: TextStyle(fontSize: 40),
            ),
            icon: const Icon(Icons.add, size: 50),
            onPressed: () {
                    return showCreateItemDialog(context, () {
                      setState(() {});
                    });
                  
            }));
  }
}
