import 'package:flutter/material.dart';

void showIncorrectDataAlert(BuildContext context, [Widget title = const Text("Укажите правильные данные!")]) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title,
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ок"))
          ],
        );
      });
}
