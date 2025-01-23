import 'package:flutter/material.dart';
import '../../requests/createItem.dart';
import 'package:flutter/services.dart';

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
              "Новый предмет",
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
                        labelText: "Название",
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
                        labelText: "Описание",
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
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: "Количество",
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
                    Navigator.pop(context);
                  },
                  child: const Text("Отмена"),
                ),
                ElevatedButton(
                  onPressed: () {
                    createItem(nameController.text, descriptionController.text,
                        int.parse(quantityController.text));
                    Navigator.pop(context);
                    refreshPage();
                  },
                  child: const Text("Создать"),
                ),
              ],
            ))
      ],
    ),
  );
}
