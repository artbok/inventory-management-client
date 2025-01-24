import 'package:flutter/material.dart';
import '../../requests/editItem.dart';

Widget editItemDialog(String name, String description, BuildContext context,
    VoidCallback refreshPage) {
  TextEditingController nameController = TextEditingController(text: name);
  TextEditingController descriptionController =
      TextEditingController(text: description);

  return Dialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
    child: Column(
      children: [
        Expanded(
            flex: 1,
            child: Text(
              "Редактирование предмета '$name'",
              style: const TextStyle(fontSize: 35),
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
                    editItem(name, description, nameController.text, descriptionController.text);
                    Navigator.pop(context);
                    refreshPage();
                  },
                  child: const Text("Подтвердить"),
                ),
              ],
            ))
      ],
    ),
  );
}
