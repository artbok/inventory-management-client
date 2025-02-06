import 'package:flutter/material.dart';
import 'package:inventory_managment/admin/dialogs/create_item_dialog.dart';
import 'package:inventory_managment/widgets/button.dart';

void showNotEnoughItemsAlert(
    BuildContext context, VoidCallback refreshPage, Map<String, dynamic> required) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 222, 173),
          title: const Text(
              maxLines: 3,
              "У вас недостаточно предметов для удовлетворения заявки."),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            buttonDialog(
              const Text("Окей",
              style: TextStyle(color: Colors.white),),
                 () {
                  Navigator.pop(context);
                },),
            buttonDialog(
              const Text("Создать необходимые предметы",
              style: TextStyle(color: Colors.white),),
                () {
                  Navigator.pop(context);
                  showCreateItemDialog(context, refreshPage,
                      required: required);
                },)
          ],
        );
      });
}
