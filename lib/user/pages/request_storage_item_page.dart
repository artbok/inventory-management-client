import 'package:flutter/material.dart';
import 'package:inventory_managment/widgets/user_navigation.dart';
import 'package:inventory_managment/requests/get_storage_items.dart';
import 'package:inventory_managment/widgets/quantity_input.dart';
import 'package:inventory_managment/requests/create_item_request.dart';
import 'package:inventory_managment/widgets/page_changer.dart';
import 'package:inventory_managment/widgets/background.dart';


class RequestStorageItemPage extends StatefulWidget {
  const RequestStorageItemPage({super.key});

  @override
  State<RequestStorageItemPage> createState() => _RequestStorageItemPageState();
}

class _RequestStorageItemPageState extends State<RequestStorageItemPage> {
  TextEditingController searchController = TextEditingController();
  int currentPage = 1;
  int totalPages = 0;
  String problem = "";
  List<Widget> inputWidgets = [];
  List<TextEditingController> controllers = [];
  Widget getItemWidget(
      int i, int id, String name, String description, int quantity, int requestsCounter) {
    if (inputWidgets.length - 1 < i) {
      controllers.add(TextEditingController());
      inputWidgets.add(quantityInput(quantity, controllers[i]));
    }
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
                title: Row(children: [
                  Expanded(flex: 2, child: Text("$name     Доступно: ${quantity}x   Запрошено: ${requestsCounter}x")),
                  Expanded(flex: 1, child: Container()),
                  Expanded(flex: 1, child: inputWidgets[i])
                ]),
                subtitle: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Text(description,
                            style: const TextStyle(fontSize: 15))),
                    Expanded(
                        flex: 1,
                        child: ElevatedButton(
                            onPressed: () async {
                              await createItemRequest(id, name, description,
                                  int.parse(controllers[i].text));
                              controllers[i].clear();
                              setState(() {});
                            },
                            child: const Text("Запросить")))
                  ],
                ))));
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
        body: background(Row(children: [
            userNavigation(1, context),
            Expanded(
                child: FutureBuilder(
                    future: getStorageItems(currentPage),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('ошибка: ${snapshot.error}');
                      } else {
                        data = snapshot.data!['data'];
                        totalPages = snapshot.data!['totalPages'];
                        List<Widget> items = [];
                        for (int i = 0; i < data.length; i++) {
                          items.add(getItemWidget(
                              i,
                              data[i]["id"],
                              data[i]["name"]!,
                              data[i]["description"]!,
                              data[i]["quantity"]!,
                              data[i]["requestsCounter"],
                              ));
                        }
                        if (items.isEmpty) {
                          items.add(const Text(
                            "Ничего не найдено :(",
                            style: TextStyle(fontSize: 40),
                          ));
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
                            child: Center(
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                  Expanded(flex: 1, child: Container()),
                                  Expanded(
                                      flex: 7,
                                      child: SingleChildScrollView(
                                          child: Column(
                                        children: items,
                                      ))),
                                  Expanded(
                                      flex: 1,
                                      child: pageChanger(currentPage,
                                          totalPages, nextPage, previousPage))
                                ])));
                      }
                    }))
          ])));
  }
}
