import 'package:flutter/material.dart';
import '../../widgets/userNavigation.dart';
import '../../requests/getItems.dart';

class UserRequestsPage extends StatefulWidget {
  const UserRequestsPage({super.key});

  @override
  State<UserRequestsPage> createState() => _UserRequestsPageState();
}

class _UserRequestsPageState extends State<UserRequestsPage> {
  TextEditingController searchController = TextEditingController();
  int currentPage = 1;
  int totalPages = 0;
  String problem = "";
  Widget getItemWidget(String name, String description, int quantity) {
    return ListTile(
      title: Text("$name     ${quantity}x"),
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
            const Expanded(flex: 2, child: Text("UserRequestsPage")),
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
        body: Center(
            child: Row(children: [
          userNavigation(1, context),
          Expanded(
              child: FutureBuilder(
                  future: getItems(currentPage),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      data = snapshot.data!['data'];
                      totalPages = snapshot.data!['totalPages'];
                      List<Widget> items = [];
                      for (int i = 0; i < data.length; i++) {
                        items.add(getItemWidget(data[i]["name"]!,
                            data[i]["description"]!, data[i]["quantity"]!));
                      }
                      return Center(
                          child: Column(
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
                                    Expanded(flex: 1, child: Container())
                                  ],
                                )),
                                Expanded(flex: 1, child: pageChanger())
                          ]));
                    }
                  }))
        ])));
  }
}
