import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_managment/requests/create_item.dart';
import 'package:inventory_managment/widgets/background.dart';
import 'package:inventory_managment/widgets/button.dart';

void showCreateItemDialog(BuildContext context, VoidCallback refreshPage,
    {Map<String, dynamic>? required}) {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  if (required != null) {
    nameController.text = required["name"];
    descriptionController.text = required["description"];
    quantityController.text = required["quantity"].toString();
  }

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          child: backgroundDialog(Column(
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
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
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
                      buttonDialog(
                        const Text("Отмена",
                        style: TextStyle(color: Colors.white),
                        ),
                        () {
                          Navigator.pop(context);
                        },
                      ),
                      buttonDialog(
                      const Text("Создать",
                      style: TextStyle(color: Colors.white),),
                       () {
                          createItem(
                              nameController.text,
                              descriptionController.text,
                              int.parse(quantityController.text));
                          Navigator.pop(context);
                          refreshPage();
                        },
                      ),
                    ],
                  ))
            ],),
          ),
        );
      });
}
