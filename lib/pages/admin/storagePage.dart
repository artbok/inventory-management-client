import 'package:flutter/material.dart';
import '../../widgets/adminNavigation.dart';
import '../../requests/getItems.dart';
import 'createItemPage.dart';
import 'giveItemToUserPage.dart';
import '../../widgets/pageChanger.dart';

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
  Widget getItemWidget(
      String name, String description, int quantity, int quantityInStorage) {
        Widget titleText = Text(
        "$name     допустимое: $quantityInStorageшт.    общее количество: ${quantity}x");
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[
                    Color.fromARGB(255, 108, 243, 213),
                    Color.fromARGB(255, 113, 219, 196),
                    Color.fromARGB(255, 19, 200, 181),
                    Color.fromARGB(255, 33, 163, 163),
                    Color.fromARGB(255, 115, 117, 165)
                  ],
                  tileMode: TileMode.clamp),
              border: Border.all(
                color: Colors.black, // Border color
                width: 2.0, // Border width
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              title: (users.isNotEmpty && quantityInStorage != 0)
                  ? Row(children: [
                      titleText,
                      ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return giveItemToUser(name, quantityInStorage,
                                      description, users, () {
                                    setState(() {});
                                  });
                                });
                          },
                          child: const Text("Выдать пользователю"))
                    ])
                  : titleText,
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
                          color: const Color.fromARGB(255, 219, 240, 35),
                          child: TextFormField(controller: searchController)),
                    ],
                  )),
              Expanded(flex: 1, child: Container()),
            ],
          ),
          backgroundColor: Colors.amber,
        ),
        body: Center(
            child: Row(children: [
          adminNavigation(0, context),
          Expanded(
              child: Container(
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: <Color>[
                                    Color.fromARGB(255, 6, 94, 209),
                                    Color.fromARGB(255, 32, 192, 93),
                                    Color.fromARGB(255, 6, 152, 209),
                                  ],
                                  tileMode: TileMode.clamp)), child: FutureBuilder(
                  future: getItems(currentPage),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('ошибка: ${snapshot.error}');
                    } else {
                      totalPages = snapshot.data!["totalPages"];
                      users = snapshot.data!["users"].cast<String>();
                      data = snapshot.data!["data"];
                      List<Widget> items = [];
                      for (int i = 0; i < data.length; i++) {
                        items.add(getItemWidget(
                            data[i]["name"]!,
                            data[i]["description"]!,
                            data[i]["quantity"]!,
                            data[i]["quantityInStorage"]));
                      }
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                                flex: 7,
                                child: Row(
                                  children: [
                                    Expanded(flex: 1, child: Container()),
                                    Expanded(
                                        flex: 2,
                                        child: SingleChildScrollView(
                                            child: Column(
                                          children: items,
                                        ))),
                                    Expanded(flex: 1, child: Container()),
                                  ],
                                )),
                            Expanded(
                                flex: 1,
                                child: pageChanger(currentPage, totalPages,
                                    nextPage, previousPage)),
                          ]);
                    }
                  })))
        ])),
        floatingActionButton: CircleAvatar(
            backgroundColor: Colors.amber,
            child: IconButton(
                style: const ButtonStyle(
                  side: WidgetStatePropertyAll(
                    BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
                icon: const Icon(Icons.add),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return createItemDialog(context, () {
                          setState(() {});
                        });
                      });
                })));
  }
}
