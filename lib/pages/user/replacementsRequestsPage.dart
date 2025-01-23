import 'package:flutter/material.dart';
import 'package:predprof/pages/user/userStoragePage.dart';
import '../../requests/getReplacementsRequests.dart';
import '../../localStorage.dart';
import '../../widgets/userNavigation.dart';

class ReplacementsRequestsPage extends StatefulWidget {
  const ReplacementsRequestsPage({super.key});

  @override
  State<ReplacementsRequestsPage> createState() =>
      _ReplacementsRequestsPageState();
}

class _ReplacementsRequestsPageState extends State<ReplacementsRequestsPage> {
  TextEditingController searchController = TextEditingController();
  int currentPage = 1;
  int totalPages = 0;
  String problem = "";
  Widget getReplacementRequestWidget(
      String itemName, int quantity, String status) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        child: ListTile(
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
      appBar: AppBar(
          title: Row(
        children: [
          const Expanded(flex: 2, child: Text("ReplacementItemsRequests")),
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
                      color: const Color.fromARGB(255, 35, 240, 185),
                      child: TextFormField(controller: searchController)),
                ],
              )),
          Expanded(flex: 1, child: Container()),
        ],
      )),
      backgroundColor: Colors.amber,
      body: Row(children: [
        userNavigation(2, context),
        Expanded(
            child: FutureBuilder(
                future: getReplacementsRequests(owner),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<dynamic> data = snapshot.data!["data"];
                    List<Widget> items = [];
                    for (int i = 0; i < data.length; i++) {
                      items.add(getReplacementRequestWidget(
                          data[i]["itemName"]!,
                          data[i]["quantity"]!,
                          data[i]["status"]!));
                    }
                    return Center(child: Column(children: items));
                  }
                }))
      ]),
      floatingActionButton: IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                      maxLines: 3,
                      "Press the repair button next to the item on the Inventory page to create Repairement Request"),
                  actionsAlignment: MainAxisAlignment.spaceAround,
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Ok")),
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
                        child: const Text("Go to Inventory"))
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
