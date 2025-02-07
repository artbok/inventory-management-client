import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_managment/widgets/button.dart';
import 'package:inventory_managment/requests/change_item_status.dart';
import 'package:inventory_managment/widgets/status_indicator.dart';
import 'package:inventory_managment/widgets/show_alert.dart';

List<String> statuses = ['Новый', 'Использованный', 'Сломанный'];

void changeStatusDialog(int itemId, String name, int quantity, String status,
    BuildContext context, VoidCallback refreshPage) {
  TextEditingController quantityController =
      TextEditingController(text: quantity.toString());
  String? errorText;
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 222, 173),
          title: Text(
            "Изменить статус для '$name'?",
            style: const TextStyle(fontSize: 35),
          ),
          content: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: [
                StatefulBuilder(builder: (context, setState) {
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
                          errorText =
                              'Пожалуйста введите число от 1 до $quantity';
                        });
                      } else {
                        setState(() {
                          errorText = null;
                        });
                      }
                    },
                  );
                }),
                StatefulBuilder(builder: (context, setState) {
                  return DropdownButton<String>(
                    dropdownColor: const Color.fromARGB(255, 255, 222, 173),
                    value: status,
                    onChanged: (String? newValue) {
                      setState(() {
                        status = newValue!;
                      });
                    },
                    items: statuses.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: statusIndicator(item),
                      );
                    }).toList(),
                  );
                }),
              ]),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
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
                "Изменить",
                style: TextStyle(color: Colors.white),
              ),
              () {
                if (errorText == null) {
                  changeStatus(itemId, int.parse(quantityController.text), status);
                  Navigator.pop(context);
                  refreshPage();
                } else {
                  showIncorrectDataAlert(context);
                }
              },
            ),
          ],
        );
      });
}
