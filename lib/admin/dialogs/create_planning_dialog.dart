import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_managment/requests/create_planning.dart';
import 'package:inventory_managment/widgets/show_alert.dart';
import 'package:inventory_managment/widgets/background.dart';
import 'package:inventory_managment/widgets/button.dart';

void showCreatePlanningDialog(BuildContext context, VoidCallback refreshPage) {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController supplierController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          child: backgroundDialog(Row(
            children: [
              Expanded(child: Container()),
              Expanded(
                child:
                  Column(children: [
                    const Expanded(
                        child: Text(
                      "Новая закупка",
                      style: TextStyle(fontSize: 35),
                    )),
                    Expanded(
                      child: TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "Название",
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: "Описание",
                        ),
                      ),
                    ),
                    Expanded(
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
                    Expanded(
                      child: TextFormField(
                        controller: supplierController,
                        decoration: const InputDecoration(
                          labelText: "Поставщик",
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          suffix: Text("€"),
                          labelText: "Планируемая цена",
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            buttonDialog(
                              const Text(
                                "Отмена",
                                style: TextStyle(color: Colors.white),
                              ),
                              () {
                                Navigator.pop(context);
                              },
                            ),
                            buttonDialog(
                              const Text(
                                "Создать",
                                style: TextStyle(color: Colors.white),
                              ),
                              () {
                                if (nameController.text.isEmpty ||
                                    descriptionController.text.isEmpty ||
                                    quantityController.text.isEmpty ||
                                    supplierController.text.isEmpty ||
                                    priceController.text.isEmpty ||
                                    int.parse(quantityController.text) == 0) {
                                  showIncorrectDataAlert(context);
                                } else {
                                  createPlanning(
                                      nameController.text,
                                      descriptionController.text,
                                      int.parse(quantityController.text),
                                      supplierController.text,
                                      int.parse(priceController.text));
                                  Navigator.pop(context);
                                  refreshPage();
                                }
                              },
                            ),
                          ],
                        ))
                  ]),
                ),
              Expanded(child: Container()),
            ],),
          ),
        );
      });
}
