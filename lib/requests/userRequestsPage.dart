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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Row(
          children: [
            const Expanded(flex: 2, child: Text("UserrequestsPage")),
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
                          ))
                    ]));
              }
            }));
  }
}
