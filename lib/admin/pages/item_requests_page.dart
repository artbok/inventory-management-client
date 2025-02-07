import 'package:flutter/material.dart';
import 'package:inventory_managment/widgets/admin_navigation.dart';
import 'package:inventory_managment/requests/get_items_requests.dart';
import 'package:inventory_managment/widgets/wrapped_item.dart';
import 'package:inventory_managment/widgets/request_status_indicator.dart';
import 'package:inventory_managment/requests/accept_item_request.dart';
import 'package:inventory_managment/requests/decline_item_request.dart';
import 'package:inventory_managment/admin/dialogs/not_enough_items_dialog.dart';

class ItemRequestsPage extends StatefulWidget {
  const ItemRequestsPage({super.key});

  @override
  State<ItemRequestsPage> createState() => _ItemRequestsPageState();
}

class _ItemRequestsPageState extends State<ItemRequestsPage> {
  TextEditingController searchController = TextEditingController();

  Widget getItemWidget(int id, String name, String description, String status,
      int quantity, String owner) {
    return wrappedItem(ListTile(
      title: (status == "Ожидает ответа")
          ? Row(children: [
              Text("$name     $quantityшт."),
              IconButton(
                  onPressed: () async {
                    Map<String, dynamic> data = await acceptItemRequest(id);
                    if (data["status"] == 'notEnoughItems') {
                      showNotEnoughItemsAlert(context, () {
                        setState(() {});
                      }, data["required"]);
                    }
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.check,
                    color: Colors.green,
                  )),
              IconButton(
                  onPressed: () async {
                    await declineItemRequest(id);
                    setState(() {});
                  },
                  icon: const Icon(Icons.close, color: Colors.red))
            ])
          : Text("$name     $quantityшт."),
      subtitle: Row(children: [
        requestStatusIndicator(status),
        Expanded(child: Container())
      ]),
    ));
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> data = [];
    return scaffoldWithNavigation(2, context,
          FutureBuilder(
              future: getItemsRequests(),
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
                  if (items.isEmpty) {
                    items.add(const Text(
                      "Ничего не найдено :(",
                      style: TextStyle(fontSize: 40),
                    ));
                  }
                  return Column(
                    children: [
                      Expanded(flex: 1, child: Container()),
                      Expanded(
                          flex: 8,
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
