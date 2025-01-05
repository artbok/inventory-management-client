import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../localStorage.dart';
import 'dart:convert';

List<dynamic> data = [
  {"name": "Золотой тунец", "description": "тот самый", "amount": "999999"},
  {
    "name": "Серебрянный тунец",
    "description": "а как без него?",
    "amount": "69"
  },
  {
    "name": "Бронзовый тунец",
    "description": "утешительный приз",
    "amount": "1"
  },
];

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

  Future<List<dynamic>> getData(int currentPage) async {
    String? username = getValue("username");
    String? password = getValue("password");
    Map<String, dynamic> params = {
      "username": username,
      "password": password,
      "page": currentPage,
    };
    var response = await http.post(
      Uri.parse('http://127.0.0.1:5000/getItems'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(params),
    );

    Map<String, dynamic> _data =
        jsonDecode(response.body) as Map<String, dynamic>;
    totalPages = _data["totalPages"];
    return _data["data"];
  }

  void createItem(String name, String description, String amount) async {
    String? username = getValue("username");
    String? password = getValue("password");
    Map<String, dynamic> params = {
      "username": username,
      "password": password,
      "name": name,
      "description": description,
      "amount": amount,
    };
    var response = await http.post(
      Uri.parse('http://127.0.0.1:5000/newItem'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(params),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                              Expanded(flex: 1, child: Container()),
                            ],
                          )),
                      Expanded(
                          flex: 1,
                          child: Row(
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
                          )),
                    ]));
              }
            }),
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
                  TextEditingController nameController =
                      TextEditingController();
                  TextEditingController descriptionController =
                      TextEditingController();

                  TextEditingController amountController =
                      TextEditingController();

                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          insetPadding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 30),
                          child: Column(
                            children: [
                              const Expanded(
                                  flex: 1,
                                  child: Text(
                                    "New item",
                                    style: TextStyle(fontSize: 35),
                                  )),
                              Expanded(
                                flex: 4,
                                child: Column(children: [
                                  Expanded(
                                      flex: 1,
                                      child: Row(children: [
                                        Expanded(flex: 1, child: Container()),
                                        Expanded(
                                          flex: 2,
                                          child: TextFormField(
                                            controller: nameController,
                                            decoration: const InputDecoration(
                                              labelText: "Name",
                                            ),
                                          ),
                                        ),
                                        Expanded(flex: 1, child: Container()),
                                      ])),
                                  Expanded(
                                      flex: 1,
                                      child: Row(children: [
                                        Expanded(flex: 1, child: Container()),
                                        Expanded(
                                          flex: 2,
                                          child: TextFormField(
                                            controller: descriptionController,
                                            decoration: const InputDecoration(
                                              labelText: "Description",
                                            ),
                                          ),
                                        ),
                                        Expanded(flex: 1, child: Container()),
                                      ])),
                                  Expanded(
                                      flex: 1,
                                      child: Row(children: [
                                        Expanded(flex: 1, child: Container()),
                                        Expanded(
                                          flex: 2,
                                          child: TextFormField(
                                            controller: amountController,
                                            keyboardType: TextInputType
                                                .number, // Numeric keyboard
                                            // inputFormatters: [
                                            //   FilteringTextInputFormatter
                                            //       .digitsOnly, // Allow only digits
                                            // ],
                                            decoration: const InputDecoration(
                                              labelText: "Amount",
                                            ),
                                          ),
                                        ),
                                        Expanded(flex: 1, child: Container()),
                                      ])),
                                ]),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          createItem(
                                              nameController.text,
                                              descriptionController.text,
                                              amountController.text);
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                        child: const Text("Create"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel"),
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        );
                      });
                })));
  }
}
