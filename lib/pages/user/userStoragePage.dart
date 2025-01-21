import 'package:flutter/material.dart';
import 'package:predprof/pages/user/replacementsRequestsPage.dart';
import 'package:predprof/pages/user/userRequestsPage.dart';
import 'package:predprof/widgets/userNavigation.dart';
import '../../requests/getUsersItems.dart';
import '../../localStorage.dart';

class UserStoragePage extends StatefulWidget {
  const UserStoragePage({super.key});

  @override
  State<UserStoragePage> createState() => UserStoragePageState();
}

class UserStoragePageState extends State<UserStoragePage> {
  TextEditingController searchController = TextEditingController();
  int currentPage = 1;
  int totalPages = 0;

  Widget getItemWidget(String name, String description, int quantity) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5), child: Container(
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
            title: Text("$name     ${quantity}x"),
            subtitle: Text(description, style: const TextStyle(fontSize: 15)),
          )


            ));

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
    String owner = getValue("username");
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Expanded(flex: 2, child: Text("Your inventory")),
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
                      return Text('Error: ${snapshot.error}');
                    } else {
                      totalPages = snapshot.data!["totalPages"];
                      data = snapshot.data!["data"];
                      List<Widget> items = [];
                      for (int i = 0; i < data.length; i++) {
                        items.add(getItemWidget(data[i]["itemName"]!,
                            data[i]["description"]!, data[i]["quantity"]!));
                      }
                      return Container(
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: <Color>[
                                    Color.fromARGB(255, 6, 94, 209),
                                    Color.fromARGB(255, 32, 192, 93),
                                    Color.fromARGB(255, 6, 152, 209),
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
                              Expanded(flex: 1, child: pageChanger()),
                              Expanded(flex: 1, child: Container())
                            ],
                          ));
                    }
                  }))
        ])));
  }
}
