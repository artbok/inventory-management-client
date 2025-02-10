import 'package:flutter/material.dart';
import 'package:inventory_managment/widgets/user_navigation.dart';
import 'package:inventory_managment/requests/get_user_items.dart';
import 'package:inventory_managment/local_storage.dart';
import 'package:inventory_managment/widgets/page_changer.dart';
import 'package:inventory_managment/user/dialogs/create_replacement_request_dialog.dart';
import '../../widgets/status_indicator.dart';

class UserStoragePage extends StatefulWidget {
  const UserStoragePage({super.key});

  @override
  State<UserStoragePage> createState() => UserStoragePageState();
}

class UserStoragePageState extends State<UserStoragePage> {
  TextEditingController searchController = TextEditingController();
  int currentPage = 1;
  int totalPages = 0;

  Widget getItemWidget(
      int id, String name, String description, int quantity, String status) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[
                    Color.fromARGB(200, 248, 201, 222),
                    Color.fromARGB(255, 226, 209, 247),
                  ],
                  tileMode: TileMode.clamp),
              border: Border.all(
                color: const Color.fromARGB(200, 47, 47, 143),
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
                title: Row(children: [
                  Text("$name     $quantityшт."),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return createReplacementRequestPage(
                                  id, name, description, quantity, () {
                                setState(() {});
                              });
                            });
                      },
                      icon: const Icon(Icons.find_replace))
                ]),
                subtitle: Row(children: [
                  statusIndicator(status),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(description,
                              style: const TextStyle(fontSize: 15))))
                ]))));
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
    String owner = getValue("username");
    return scaffoldWithUserNavigation(
        0,
        context,
        FutureBuilder(
            future: getUserItems(
              owner,
              currentPage,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Ошибка: ${snapshot.error}');
              } else {
                totalPages = snapshot.data!["totalPages"];
                data = snapshot.data!["data"];
                List<Widget> items = [];
                for (int i = 0; i < data.length; i++) {
                  items.add(getItemWidget(
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
                  children: [
                    Expanded(
                        flex: 6,
                        child: Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: SingleChildScrollView(
                                    child: Column(
                                  children: items,
                                ))))),
                    pageChanger(currentPage, totalPages, nextPage, previousPage)
                  ],
                );
              }
            }));
  }
}
