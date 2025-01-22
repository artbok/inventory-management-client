import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../requests/createItemRequest.dart';
import '../../localStorage.dart';

Widget requestCustomItemPage(BuildContext context, VoidCallback refreshPage) {
  TextEditingController quantityController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: Column(children: [
        const Expanded(
            flex: 1,
            child: Padding(
                padding: EdgeInsets.all(40.0),
                child: Text(
                  "Request custom item",
                  style: TextStyle(fontSize: 40),
                ))),
        Expanded(flex: 1, child: Container()),
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Item name',
                  border: OutlineInputBorder(),
                ),
              ),
            )),
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Quantity of items',
                  border: OutlineInputBorder(),
                ),
              ),
            )),
        Expanded(
            flex: 1,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      child: const Text("Cancel"),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  ElevatedButton(
                    child: const Text("Submit"),
                    onPressed: () async {
                      if (nameController.text.isNotEmpty &&
                          quantityController.text.isNotEmpty &&
                          int.tryParse(quantityController.text) != null) {
                        String owner = getValue("username");
                        await createItemRequest(true, nameController.text,
                            int.parse(quantityController.text), owner);
                        Navigator.pop(context);
                        refreshPage();
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Provide correct data"),
                                actionsAlignment: MainAxisAlignment.center,
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("OK"))
                                ],
                              );
                            });
                      }
                    },
                  ),
                ]))
      ]));
}
