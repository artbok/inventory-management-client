import 'package:flutter/material.dart';
import 'package:inventory_managment/requests/get_replacements_requests.dart';
import 'package:inventory_managment/local_storage.dart';
import 'package:inventory_managment/widgets/user_navigation.dart';
import 'package:inventory_managment/widgets/wrapped_item.dart';
import 'package:inventory_managment/widgets/request_status_indicator.dart';

class ReplacementRequestsPage extends StatefulWidget {
  const ReplacementRequestsPage({super.key});

  @override
  State<ReplacementRequestsPage> createState() =>
      _ReplacementRequestsPageState();
}

class _ReplacementRequestsPageState extends State<ReplacementRequestsPage> {
  TextEditingController searchController = TextEditingController();
  int currentPage = 1;
  int totalPages = 0;
  String problem = "";
  Widget getReplacementRequestWidget(
      String itemName, int quantity, String status) {
    return wrappedItem(ListTile(
      title: Text("$itemName     ${quantity}x"),
      subtitle: Row(children: [requestStatusIndicator(status), Expanded(child: Container())]),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    String owner = getValue('username');
    return scaffoldWithUserNavigation(2, context, 
 FutureBuilder(
                future: getReplacementRequests(owner),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('ошибка: ${snapshot.error}');
                  } else {
                    List<dynamic> data = snapshot.data!["data"];
                    List<Widget> items = [];
                    for (int i = 0; i < data.length; i++) {
                      items.add(getReplacementRequestWidget(data[i]["name"]!,
                          data[i]["quantity"]!, data[i]["status"]!));
                    }
                    if (items.isEmpty) {
                      items.add(const Text(
                        "Ничего не найдено :(",
                        style: TextStyle(fontSize: 40),
                      ));
                    }
                    return Center(child: Column(children: items));
                  }
               }));
  }
}
