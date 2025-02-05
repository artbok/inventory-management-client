import 'package:flutter/material.dart';
import 'package:inventory_managment/admin/dialogs/create_item_dialog.dart';

void showNotEnoughItemsAlert(
    BuildContext context, VoidCallback refreshPage, Map<String, dynamic> required) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
              maxLines: 3,
              "У вас недостаточно предметов для удовлетворения заявки."),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Окей")),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  showCreateItemDialog(context, refreshPage,
                      required: required);
                },
                child: const Text("Создать необходимые предметы"))
          ],
        );
      });
}
