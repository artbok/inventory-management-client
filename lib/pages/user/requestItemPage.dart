import 'package:flutter/material.dart';
import '../../widgets/userNavigation.dart';
import '../../requests/getItems.dart';
import '../../widgets/quantityInput.dart';
import '../../requests/createItemRequest.dart';
import '../../localStorage.dart';
import '../../widgets/pageChanger.dart';
import '../../widgets/background.dart';


class RequestItemPage extends StatefulWidget {
  const RequestItemPage({super.key});

  @override
  State<RequestItemPage> createState() => _RequestItemPageState();
}

class _RequestItemPageState extends State<RequestItemPage> {
  TextEditingController searchController = TextEditingController();
  int currentPage = 1;
  int totalPages = 0;
  String problem = "";
  List<Widget> inputWidgets = [];
  List<TextEditingController> controllers = [];
  Widget getItemWidget(
      int i, int id, String name, String description, int quantity) {
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
                  Expanded(flex: 2, child: Text("$name     ${quantity}x")),
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
                              String username = getValue("username");
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
        appBar: AppBar(
            title: Row(
          children: [
            const Expanded(flex: 2, child: Text("Запросы предметов")),
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
                        color: const Color.fromARGB(255, 35, 240, 185),
                        child: TextFormField(controller: searchController)),
                  ],
                )),
            Expanded(flex: 1, child: Container()),
          ],
        )),
        body: background(Row(children: [
          Container(
              child: Center(
                  child: Row(children: [
            userNavigation(1, context),
            Expanded(
                child: FutureBuilder(
                    future: getItems(currentPage),
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
                              data[i]["quantity"]!));
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
          ])))
        ])));
  }
}
