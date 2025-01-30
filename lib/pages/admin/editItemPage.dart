import 'package:flutter/material.dart';
import '../../requests/editItem.dart';
import 'package:flutter/services.dart';

Widget editItemDialog(String name, String description, int quantity,
    int minQuantity, String status, BuildContext context, VoidCallback refreshPage) {
  TextEditingController nameController = TextEditingController(text: name);
  TextEditingController descriptionController =
      TextEditingController(text: description);
  TextEditingController quantityController =
      TextEditingController(text: quantity.toString());
  String? errorText;
  List<String> statuses = ["новый", "используемый", "сломанный"];
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
              child: StatefulBuilder(builder: (context, setState) {
                        return
              DropdownButton<String>(
        value: status,
        onChanged: (String? newValue) {
          setState(() {
            status = newValue!;
          });
        },
        items: statuses.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
      );}),
            ),
            Expanded(
                flex: 1,
                child: Row(children: [
                  Expanded(flex: 1, child: Container()),
                  Expanded(
                      flex: 2,
                      child: StatefulBuilder(builder: (context, setState) {
                        return TextFormField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                        
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            errorText: errorText,
                            labelText: "Количество",
                          ),
                          onChanged: (value) {
                            final int? number = int.tryParse(value);
                            if (number == null || number < minQuantity) {
                              setState(() {
                                errorText = 'Количество должно быть больше $minQuantity';
                              });
                            } else {
                              setState(() {
                                errorText = null;
                              });
                            }
                          },
                        );
                      })),
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
                    editItem(name, description, nameController.text, int.parse(quantityController.text),
                        descriptionController.text);
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
