import 'package:flutter/material.dart';
import 'package:inventory_managment/requests/get_replacements_requests.dart';
import 'package:inventory_managment/widgets/admin_navigation.dart';
import 'package:inventory_managment/widgets/wrapped_item.dart';
import 'package:inventory_managment/widgets/request_status_indicator.dart';
import 'package:inventory_managment/requests/accept_replacement_request.dart';
import 'package:inventory_managment/requests/decline_replacement_request.dart';
import 'package:inventory_managment/admin/dialogs/not_enough_items_dialog.dart';

class ReplacementRequestsPage extends StatefulWidget {
  const ReplacementRequestsPage({super.key});

  @override
  State<ReplacementRequestsPage> createState() =>
      _ReplacementRequestsPageState();
}

class _ReplacementRequestsPageState extends State<ReplacementRequestsPage> {
  TextEditingController searchController = TextEditingController();

  Widget getItemWidget(
      BuildContext context, String name, String status, int quantity, int id) {
    return wrappedItem(ListTile(
      title: (status == "Ожидает ответа")
          ? Row(children: [
              Text("$name     $quantityшт."),
              IconButton(
                  onPressed: () async {
                    Map<String, dynamic> data =
                        await acceptReplacementRequest(id);
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
                    await declineReplacementRequest(id);
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
    return 
      scaffoldWithNavigation(1, context, FutureBuilder(
              future: getReplacementRequests(),
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
                        context,
                        data[i]["name"]!,
                        data[i]["status"]!,
                        data[i]["quantity"]!,
                        data[i]["id"]!));
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
