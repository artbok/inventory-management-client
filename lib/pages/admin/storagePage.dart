import 'package:flutter/material.dart';
import 'package:predprof/pages/user/replacementsRequestsPage.dart';
import 'package:predprof/pages/user/userRequestsPage.dart';
import 'package:predprof/widgets/adminNavigation.dart';
import '../../requests/getItems.dart';
import 'createItemPage.dart';
import 'giveItemToUserPage.dart';

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
        "$name     available: ${quantityInStorage}x    total: ${quantity}x");
    return ListTile(
      title: (users.isNotEmpty && quantityInStorage != 0)
          ? Row(children: [
              titleText,
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return giveItemToUser(
                              name, quantityInStorage, description, users, () {
                            setState(() {});
                          });
                        });
                  },
                  child: const Text("Give to user"))
            ])
          : titleText,
      subtitle: Text(description, style: const TextStyle(fontSize: 15)),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget pageChanger() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            if (currentPage != 1) {
              setState(() {
                currentPage--;
              });
            }
          },
          child: const Icon(Icons.arrow_back_rounded),
        ),
        Text("   Page $currentPage/$totalPages   "),
        InkWell(
            onTap: () {
              if (currentPage != totalPages) {
                setState(() {
                  currentPage++;
                });
              }
            },
            child: const Icon(Icons.arrow_forward_rounded))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> data = [];
     int selectedIndex = 0;
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Expanded(flex: 2, child: Text("StoragePage")),
              Expanded(flex: 2, child: Container()),
              Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "search",
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
        Expanded(child: 
        FutureBuilder(
            future: getItems(currentPage),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
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
                            flex: 5,
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
                        Expanded(flex: 1, child: pageChanger()),
                      ]);}}))
                ])),
        floatingActionButton: CircleAvatar(
            backgroundColor: Colors.amber,
            child: IconButton(
                style: const ButtonStyle(
                  side: WidgetStatePropertyAll(
                    BorderSide(
                        color: Colors.black,
                        width: 2.0), // Customize border color and width
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
