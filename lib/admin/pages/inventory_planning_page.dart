import 'package:flutter/material.dart';
import 'package:inventory_managment/widgets/admin_navigation.dart';
import 'package:inventory_managment/requests/get_planings.dart';
import 'package:inventory_managment/requests/change_planning_status.dart';
import 'package:inventory_managment/admin/dialogs/create_planning_dialog.dart';
import 'package:inventory_managment/widgets/background.dart';
import 'package:inventory_managment/widgets/wrapped_item.dart';

class InventoryPlanningPage extends StatefulWidget {
  const InventoryPlanningPage({super.key});

  @override
  State<InventoryPlanningPage> createState() => _InventoryPlanningPageState();
}

class _InventoryPlanningPageState extends State<InventoryPlanningPage> {
  TextEditingController searchController = TextEditingController();
  bool expanded1 = true;
  bool expanded2 = false;
  int totalPages = 0;
  String problem = "";
  List<String> users = [];

  Widget getPlanWidget(int id, String itemName, String itemDescription,
      int itemQuantity, int price, String supplier, bool completed) {
    return wrappedItem(Row(children: [
      Checkbox(
          value: completed,
          onChanged: (bool? completed) async {
            await changePlanningStatus(id, completed!);
            setState(() {});
          }),
      Expanded(
          child: ListTile(
              title: Text("$itemName  $itemQuantityшт. $price€",
                  overflow: TextOverflow.ellipsis),
              subtitle: Text("$supplier | $itemDescription",
                  style: const TextStyle(fontSize: 15),
                  overflow: TextOverflow.ellipsis)))
    ]));
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> data1 = [];
    List<dynamic> data2 = [];
    return Scaffold(
        body: background(Row(children: [
          adminNavigation(3, context),
          Expanded(
              child: FutureBuilder(
                  future: getPlanings(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else if (snapshot.hasError) {
                      return Text('ошибка: ${snapshot.error}');
                    } else {
                      data1 = snapshot.data!["uncompletedPlannings"];
                      data2 = snapshot.data!["completedPlannings"];
                      List<Widget> uncompletedPlannings = [];
                      List<Widget> completedPlannings = [];
                      for (int i = 0; i < data1.length; i++) {
                        uncompletedPlannings.add(getPlanWidget(
                            data1[i]["id"],
                            data1[i]["itemName"],
                            data1[i]["itemDescription"],
                            data1[i]["itemQuantity"],
                            data1[i]["price"],
                            data1[i]["supplier"],
                            data1[i]["completed"]));
                      }
                      for (int i = 0; i < data2.length; i++) {
                        completedPlannings.add(getPlanWidget(
                            data2[i]["id"],
                            data2[i]["itemName"],
                            data2[i]["itemDescription"],
                            data2[i]["itemQuantity"],
                            data2[i]["price"],
                            data2[i]["supplier"],
                            data2[i]["completed"]));
                      }
                      if (uncompletedPlannings.isEmpty) {
                        uncompletedPlannings.add(const Center(
                            child: Text(
                          "Тут ничего нет :)",
                          style: TextStyle(fontSize: 40),
                        )));
                      }
                      if (completedPlannings.isEmpty) {
                        completedPlannings.add(const Center(
                            child: Text(
                          "Тут ничего нет :(",
                          style: TextStyle(fontSize: 40),
                        )));
                      }
                      return StatefulBuilder(builder: (context, setState) {
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                  flex: 8,
                                  child: Column(children: [
                                    ExpansionTile(
                                        title:
                                            const Text("Невыполненные закупки"),
                                        initiallyExpanded: expanded1,
                                        trailing: Icon(
                                          expanded1
                                              ? Icons.arrow_drop_down_circle
                                              : Icons.arrow_drop_down,
                                        ),
                                        onExpansionChanged: (bool expanded) {
                                          setState(() {
                                            expanded1 = expanded;
                                          });
                                        },
                                        children: [
                                          SingleChildScrollView(
                                              child: Column(
                                            children: uncompletedPlannings,
                                          )),
                                        ]),
                                    ExpansionTile(
                                        initiallyExpanded: expanded2,
                                        title:
                                            const Text("Выполненные закупки"),
                                        trailing: Icon(
                                          expanded2
                                              ? Icons.arrow_drop_down_circle
                                              : Icons.arrow_drop_down,
                                        ),
                                        onExpansionChanged: (bool expanded) {
                                          setState(() {
                                            expanded2 = expanded;
                                          });
                                        },
                                        children: [
                                          SingleChildScrollView(
                                              child: Column(
                                            children: completedPlannings,
                                          )),
                                        ]),
                                  ])),
                            ]);
                      });
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
              return showCreatePlanningDialog(context, () {
                setState(() {});
              });
            }));
  }
}
