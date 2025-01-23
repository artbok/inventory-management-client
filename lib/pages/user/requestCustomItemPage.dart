import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../requests/createItemRequest.dart';
import '../../localStorage.dart';
import '../../widgets/showIncorrectDataAlert.dart';

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
                  ElevatedButton(
                      child: const Text("Отмена"),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  ElevatedButton(
                    child: const Text("Сохранить"),
                    onPressed: () async {
                      if (nameController.text.isNotEmpty &&
                          quantityController.text.isNotEmpty &&
                          int.tryParse(quantityController.text) != null) {
                        Navigator.pop(context);
                        String owner = getValue("username");
                        await createItemRequest(true, nameController.text,
                            int.parse(quantityController.text), owner);
                        
                        refreshPage();
                      } else {
                        showIncorrectDataAlert(context);
                      }
                    },
                  ),
                ]))
      ]));
}
