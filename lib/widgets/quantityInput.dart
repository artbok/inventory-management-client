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
        decoration: InputDecoration(
          labelText: 'quantity of items',
          errorText: errorText,
          border: const OutlineInputBorder(),
        ),
        onChanged: (value) {
          final int? number = int.tryParse(value);
          if (number == null || number < 1 || number > quantityAtStorage) {
            setState(() {
              errorText =
                  'Number should be beetween 1 and $quantityAtStorage';
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
