import 'package:flutter/material.dart';
import 'package:inventory_managment/user/pages/user_storage_page.dart';
import 'package:inventory_managment/requests/get_replacements_requests.dart';
import 'package:inventory_managment/local_storage.dart';
import 'package:inventory_managment/widgets/user_navigation.dart';
import 'package:inventory_managment/widgets/background.dart';
import 'package:inventory_managment/widgets/wrapped_item.dart';


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
          subtitle: Text(status, style: const TextStyle(fontSize: 15)),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(20),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    String owner = getValue('username');
    return Scaffold(
      body: background(Row(children: [
        userNavigation(2, context),
        Expanded(
            child: FutureBuilder(
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
                      items.add(getReplacementRequestWidget(
                          data[i]["name"]!,
                          data[i]["quantity"]!,
                          data[i]["status"]!));
                    }
                    if (items.isEmpty) {
                      items.add(const Text(
                        "Ничего не найдено :(",
                        style: TextStyle(fontSize: 40),
                      ));
                    }
                    return Center(child: Column(children: items));
                  }
                }))
      ])),
      floatingActionButton: IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                      maxLines: 3,
                      "Нажмите кнопку ремонта рядом с товаром на странице инвентаря, чтобы создать запрос на ремонт"),
                  actionsAlignment: MainAxisAlignment.spaceAround,
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Окей")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  const UserStoragePage(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                        child: const Text("Перейти к инвентарю"))
                  ],
                );
              });
        },
        style: const ButtonStyle(
          side: WidgetStatePropertyAll(
            BorderSide(
                color: Colors.black,
                width: 2.0), // Customize border color and width
          ),
        ),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
