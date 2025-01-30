import 'package:flutter/material.dart';
import 'package:predprof/widgets/adminNavigation.dart';
import '../../requests/getItemsRequests.dart';

class ItemsRequestsPage extends StatefulWidget {
  const ItemsRequestsPage({super.key});

  @override
  State<ItemsRequestsPage> createState() => ItemsRequestsState();
}

class ItemsRequestsState extends State<ItemsRequestsPage> {
  TextEditingController searchController = TextEditingController();

  Widget getItemWidget(String name, String status, int quantity) {
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
                color: Colors.black,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              title: Text("$name     ${quantity}x"),
              subtitle: Text(status, style: const TextStyle(fontSize: 15)),
            )));
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> data = [];
    return Scaffold(
        appBar: AppBar(
            title: Row(
          children: [
            const Expanded(flex: 2, child: Text("Предметы")),
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
        )),
        body: Center(
            child: Row(children: [
          adminNavigation(2, context),
          Expanded(
              child: FutureBuilder(
                  future: getItemsRequests(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Ошибка: ${snapshot.error}');
                    } else {
                      data = snapshot.data!["data"];
                      List<Widget> items = [];
                      for (int i = 0; i < data.length; i++) {
                        items.add(getItemWidget(data[i]["itemName"]!,
                            data[i]["status"]!, data[i]["itemQuantity"]!));
                      }
                      if (items.isEmpty) {
                        items.add(const Text("Ничего не найдено :("));
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
                                flex: 7,
                                child: SingleChildScrollView(
                                    child: Column(
                                  children: items,
                                ))),
                            Expanded(flex: 1, child: Container())
                          ],
                        ),
                      );
                    }
                  }))
        ])));
  }
}
