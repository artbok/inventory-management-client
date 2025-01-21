import 'package:flutter/material.dart';
import '../requests/createItem.dart';

Widget createItemDialog(BuildContext context, VoidCallback refreshPage) {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityController = TextEditingController();


  return Dialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
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
                      controller: quantityController,
                      keyboardType: TextInputType.number, // Numeric keyboard
                      // inputFormatters: [
                      //   FilteringTextInputFormatter
                      //       .digitsOnly, // Allow only digits
                      // ],
                      decoration: const InputDecoration(
                        labelText: "Quantity",
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    createItem(nameController.text, descriptionController.text,
                        int.parse(quantityController.text));
                    Navigator.pop(context);
                    refreshPage();
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
}
