import 'package:flutter/material.dart';
import 'package:inventory_managment/widgets/background.dart';
import 'package:inventory_managment/requests/get_replacements_requests.dart';
import 'package:inventory_managment/widgets/admin_navigation.dart';
import 'package:inventory_managment/widgets/wrapped_item.dart';

class ReplacementRequestsPage extends StatefulWidget {
  const ReplacementRequestsPage({super.key});

  @override
  State<ReplacementRequestsPage> createState() =>
      _ReplacementRequestsPageState();
}

class _ReplacementRequestsPageState extends State<ReplacementRequestsPage> {
  TextEditingController searchController = TextEditingController();

  Widget getItemWidget(String name, String status, int quantity) {
    return wrappedItem(ListTile(
      title: Row(children: [
        Text("$name     $quantityшт."),
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.check,
              color: Colors.green,
            )),
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.close, color: Colors.red))
      ]),
      subtitle: Text(status, style: const TextStyle(fontSize: 15)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> data = [];
    return Scaffold(
        body: background(Row(children: [
      adminNavigation(1, context),
      Expanded(
          child: FutureBuilder(
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
                    items.add(getItemWidget(data[i]["name"]!,
                        data[i]["status"]!, data[i]["quantity"]!));
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
                          flex: 7,
                          child: SingleChildScrollView(
                              child: Column(
                            children: items,
                          ))),
                      Expanded(flex: 1, child: Container())
                    ],
                  );
                }
              }))
    ])));
  }
}
