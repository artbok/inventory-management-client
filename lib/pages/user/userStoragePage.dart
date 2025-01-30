import 'package:flutter/material.dart';
import '../../widgets/userNavigation.dart';
import '../../requests/getUsersItems.dart';
import '../../localStorage.dart';
import '../../widgets/pageChanger.dart';
import 'createReplacementRequestPage.dart';
import '../../widgets/background.dart';


class UserStoragePage extends StatefulWidget {
  const UserStoragePage({super.key});

  @override
  State<UserStoragePage> createState() => UserStoragePageState();
}

class UserStoragePageState extends State<UserStoragePage> {
  TextEditingController searchController = TextEditingController();
  int currentPage = 1;
  int totalPages = 0;

  Widget getItemWidget(int id, String name, String description, int quantity) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[
                    // Color.fromARGB(255, 236, 221, 208),
                    Color.fromARGB(200, 248, 201, 222),
                    Color.fromARGB(255, 226, 209, 247),
                  ],
                  tileMode: TileMode.clamp),
              border: Border.all(
                color: const Color.fromARGB(200, 47, 47, 143), // Border color
                width: 2.0, // Border width
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
              subtitle: Text(description, style: const TextStyle(fontSize: 15)),
            )));
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
    return Scaffold(
        body: background(Row(children: [
      Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[
                  // Color.fromARGB(255, 236, 221, 208),
                  Color.fromARGB(200, 248, 201, 222),
                  Color.fromARGB(255, 226, 209, 247),
                ],
                tileMode: TileMode.clamp),
          ),
          child: Row(children: [
            userNavigation(0, context),
            Expanded(
                child: FutureBuilder(
                    future: getUsersItems(
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
                              data[i]["quantity"]!));
                        }
                        if (items.isEmpty) {
                          items.add(const Text(
                            "Ничего не найдено :(",
                            style: TextStyle(fontSize: 40),
                          ));
                        }
                        return Container(
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: <Color>[
                                      Color.fromARGB(255, 51, 51, 124),
                                      Color.fromARGB(255, 91, 91, 177),
                                      Color.fromARGB(255, 111, 131, 191),
                                      Color.fromARGB(255, 164, 168, 217),
                                      Color.fromARGB(255, 164, 168, 217),
                                      Color.fromARGB(255, 111, 131, 191),
                                      Color.fromARGB(255, 91, 91, 177),
                                      Color.fromARGB(255, 51, 51, 124),
                                    ],
                                    tileMode: TileMode.clamp)),
                            child: Column(
                              children: [
                                Expanded(flex: 1, child: Container()),
                                Expanded(
                                    flex: 6,
                                    child: SingleChildScrollView(
                                        child: Column(
                                      children: items,
                                    ))),
                                Expanded(
                                    flex: 1,
                                    child: pageChanger(currentPage, totalPages,
                                        nextPage, previousPage)),
                                Expanded(flex: 1, child: Container())
                              ],
                            ));
                      }
                    }))
          ]))
    ])));
  }
}
