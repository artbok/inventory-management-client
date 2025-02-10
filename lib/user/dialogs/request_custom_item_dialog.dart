import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_managment/requests/create_item_request.dart';
import 'package:inventory_managment/widgets/show_alert.dart';
import '../../widgets/button.dart';
import '../../widgets/background.dart';

Widget requestCustomItemDialog(BuildContext context, VoidCallback refreshPage) {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: backgroundDialog(Column(children: [
        const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Заказать пользовательский предмет",
              style: TextStyle(fontSize: 40),
            )),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Название предмета',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Описание предмета',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Количество предметов',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buttonDialog(
                              const Text(
                                "Отмена",
                                style: TextStyle(color: Colors.white),
                              ), () {
                            Navigator.pop(context);
                          }),
                          buttonDialog(
                            const Text("Сохранить",
                                style: TextStyle(color: Colors.white)),
                            () async {
                              if (nameController.text.isNotEmpty &&
                                  quantityController.text.isNotEmpty &&
                                  int.tryParse(quantityController.text) !=
                                      null) {
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
                        ]))))
      ])));
}
