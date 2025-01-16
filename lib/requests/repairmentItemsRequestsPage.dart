import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../localStorage.dart';
import 'dart:convert';
import 'userRequestsPage.dart';

class RepairmentItemsRequestsPage extends StatefulWidget {
  const RepairmentItemsRequestsPage({super.key});

  @override
  State<RepairmentItemsRequestsPage> createState() =>
      _RepairmentItemsRequestsPageState();
}

class _RepairmentItemsRequestsPageState
    extends State<RepairmentItemsRequestsPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Row(
          children: [
            const Expanded(flex: 2, child: Text("RepairmentItemsRequestsPage")),
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
        body: FutureBuilder(
            future: getData(currentPage),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                data = snapshot.data!;
                List<Widget> items = [];
                for (int i = 0; i < data.length; i++) {
                  items.add(getItemWidget(data[i]["name"]!,
                      data[i]["description"]!, data[i]["amount"]!));
                }
                return Center(
                    child: Row(children: [
                  Expanded(
                      flex: 5,
                      child: Column(children: [
                        Expanded(flex: 1, child: pageChanger()),
                        Expanded(flex: 1, child: Container())
                      ])),
                  Expanded(
                          flex: 2,
                          child: Row(children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation1, animation2) =>
                                              const UserRequestsPage(),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ),
                                  );
                                },
                                child: const Text("bebra")),
                            ElevatedButton(
                                child: const Text("bebra2"),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                const RequestItemPage(),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero,
                                      ));
                                })
                          ]))
                ]));
              }
            }));
  }
}
