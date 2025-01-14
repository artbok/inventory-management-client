import 'package:flutter/material.dart';
import '../requests/getItemsOnPage.dart';

class UserStoragePage extends StatefulWidget {
  const UserStoragePage({super.key});

  @override
  State<UserStoragePage> createState() => UserStoragePageState();
}

class UserStoragePageState extends State<UserStoragePage> {
  TextEditingController searchController = TextEditingController();
  int currentPage = 1;
  int totalPages = 0;
  String problem = "";
  Widget getItemWidget(String name, String description, String amount) {
    return ListTile(
      title: Text("$name     ${amount}x"),
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
        body: FutureBuilder(
            future: getItemsOnPage(
              currentPage,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                totalPages = snapshot.data!["totalPages"];
                data = snapshot.data!["data"];
                List<Widget> items = [];
                for (int i = 0; i < data.length; i++) {
                  items.add(getItemWidget(data[i]["name"]!,
                      data[i]["description"]!, data[i]["amount"]!));
                }
                return Center(
                    child: Row(children: [
                  Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          Expanded(flex: 1, child: Container()),
                          Expanded(
                              flex: 6,
                              child: SingleChildScrollView(
                                  child: Column(
                                children: items,
                              ))),
                          Expanded(flex: 1, child: pageChanger()),
                          Expanded(flex: 1, child: Container())
                        ],
                      )),
                  Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Expanded(
                              flex: 1, child: Container(color: Colors.blue)),
                          Expanded(
                              flex: 1, child: Container(color: Colors.green))
                        ],
                      ))
                ]));
              }
            }));
  }
}
