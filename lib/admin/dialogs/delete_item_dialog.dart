import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_managment/requests/delete_item.dart';
import 'package:inventory_managment/widgets/button.dart';

void deleteItemDialog(int itemId, String name, int quantity, BuildContext context,
    VoidCallback refreshPage) {
  TextEditingController quantityController =
      TextEditingController(text: quantity.toString());
  String? errorText;
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 222, 173),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          title: Text(
            "Удаление предмета '$name'",
            style: const TextStyle(fontSize: 35),
          ),
          content: StatefulBuilder(builder: (context, setState) {
            return TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Количество предметов',
                errorText: errorText,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                final int? number = int.tryParse(value);
                if (number == null || number < 1 || number > quantity) {
                  setState(() {
                    errorText = 'Пожалуйста введите число от 1 до $quantity';
                  });
                } else {
                  setState(() {
                    errorText = null;
                  });
                }
              },
            );
          }),
          actions: [
            buttonDialog(
              const Text("Отмена",
              style: TextStyle(color: Colors.white),),
               () {
                Navigator.pop(context);
              },
            ),
            buttonDialog(
              const Text("Удалить",
              style: TextStyle(color: Colors.white),),
               () {
                if (errorText == null) {
                  deleteItem(itemId, int.parse(quantityController.text));
                  Navigator.pop(context);
                  refreshPage();
                }
              },
            ),
          ],
        );
      });
}
