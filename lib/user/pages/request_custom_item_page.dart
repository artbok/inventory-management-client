import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_managment/requests/create_item_request.dart';
import 'package:inventory_managment/widgets/show_alert.dart';
import '../../widgets/button.dart';

Widget requestCustomItemPage(BuildContext context, VoidCallback refreshPage) {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: Column(children: [
        const Expanded(
            flex: 1,
            child: Padding(
                padding: EdgeInsets.all(40.0),
                child: Text(
                  "Заказать пользовательский предмет",
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
                  labelText: 'Название предмета',
                  border: OutlineInputBorder(),
                ),
              ),
            )),
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Описание предмета',
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
                  labelText: 'Количество предметов',
                  border: OutlineInputBorder(),
                ),
              ),
            )),
        Expanded(
            flex: 1,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(child: elButton(
                      const Text("Отмена"),
                      () {
                        Navigator.pop(context);
                      })),
                  ElevatedButton(
                    child: const Text("Сохранить"),
                    onPressed: () async {
                      if (nameController.text.isNotEmpty &&
                          quantityController.text.isNotEmpty &&
                          int.tryParse(quantityController.text) != null) {
                        Navigator.pop(context);
                        await createItemRequest(
                            null,
                            nameController.text,
                            descriptionController.text,
                            int.parse(quantityController.text));

                        refreshPage();
                      } else {
                        showIncorrectDataAlert(context);
                      }
                    },
                  ),
                ]))
      ]));
}
