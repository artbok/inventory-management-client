import 'package:flutter/material.dart';
import 'package:inventory_managment/widgets/button.dart';
import 'package:inventory_managment/widgets/user_navigation.dart';
import 'package:inventory_managment/requests/get_storage_items.dart';
import 'package:inventory_managment/requests/create_item_request.dart';
import 'package:inventory_managment/widgets/page_changer.dart';
import 'package:inventory_managment/widgets/wrapped_item.dart';
import 'package:flutter/services.dart';

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
  Widget getItemWidget(int i, int id, String name, String description,
      int quantity, int requestsCounter) {
    if (inputWidgets.length - 1 < i) {
      controllers.add(TextEditingController());
      inputWidgets.add(TextField(
        controller: controllers[i],
        maxLength: 9,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          labelText: 'Количество',
          border: OutlineInputBorder(),
        ),
      ));
    }
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: wrappedItem(ListTile(
            title: Row(children: [
              Expanded(
                  child: Text(
                      "$name     Доступно: ${quantity}x   Запрошено: ${requestsCounter}x")),
              SizedBox(width: 130, child: inputWidgets[i])
            ]),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(description, style: const TextStyle(fontSize: 15)),
                button(
                  const Text(
                    "Запросить",
                    style: TextStyle(color: Colors.black),
                  ),
                  () async {
                    await createItemRequest(
                        id, name, description, int.parse(controllers[i].text));
                    controllers[i].clear();
                    setState(() {});
                  },
                )
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
    return scaffoldWithUserNavigation(
        1,
        context,
        FutureBuilder(
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
                return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                              child: SingleChildScrollView(
                                  child: Column(
                            children: items,
                          ))),
                          pageChanger(
                              currentPage, totalPages, nextPage, previousPage)
                        ]));
              }
            }));
  }
}
