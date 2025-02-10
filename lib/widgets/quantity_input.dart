import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget quantityInput(int quantityAtStorage, TextEditingController controller) {
  String? errorText;
  return StatefulBuilder(builder: (context, setState) {
    return Center(
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 9,
        decoration: InputDecoration(
          labelText: 'Количество',
          errorText: errorText,
          border: const OutlineInputBorder(),
        ),
        onChanged: (value) {
          final int? number = int.tryParse(value);
          if (number == null || number < 1 || number > quantityAtStorage) {
            setState(() {
              errorText =
                  'Введите число от 1 до $quantityAtStorage';
            });
          } else {
            setState(() {
              errorText = null;
            });
          }
        },
      ),
    );
  });
}
