import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_managment/requests/give_item.dart';
import 'package:inventory_managment/widgets/show_alert.dart';


Widget giveItemToUser(int itemId, String name, int quantityAtStorage, String description,
    List<String> users, VoidCallback refreshPage) {
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  bool flag = false;
  String? errorText;

  return StatefulBuilder(builder: (context, setState) {
    return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
        child: Column(
          children: [
            Expanded(
                flex: 1,
                child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text(
                      "Выдать $name пользователю",
                      style: const TextStyle(fontSize: 40),
                    ))),
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return users;
                    }
                    return users.where((String item) {
                      return item.contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  onSelected: (String selection) {
                    setState(() {
                      controller1.text = selection;
                      flag = true;
                    });
                  },
                  fieldViewBuilder:
                      (context, controller1, focusNode, onEditingComplete) {
                    return TextField(
                      controller: controller1,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: 'Выбрать пользователя...',
                        border: const OutlineInputBorder(),
                        errorText:
                            !flag ? 'Пожалуйста выберете допустимый вариант' : null,
                      ),
                      onChanged: (value) {
                        setState(() {
                          flag = users.contains(value.toLowerCase());
                        });
                      },
                    );
                  },
                ),
              ),
            ),
            Expanded(flex: 1, child: Container()),
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: TextField(
                    controller: controller2,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Количество предметов',
                      errorText: errorText,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      final int? number = int.tryParse(value);
                      if (number == null ||
                          number < 1 ||
                          number > quantityAtStorage) {
                        setState(() {
                          errorText =
                              'Пожалуйста введите число от 1 до $quantityAtStorage';
                        });
                      } else {
                        setState(() {
                          errorText = null;
                        });
                      }
                    },
                  ),
                )),
            Expanded(
                flex: 1,
                child: ElevatedButton(
                    child: const Text("Подтвердить"),
                    onPressed: () async {
                      if (flag && errorText == null) {
                        Navigator.pop(context);
                        await giveItem(controller1.text, itemId, 
                            int.parse(controller2.text));
                        refreshPage();
                      } else {
                        showIncorrectDataAlert(context);
                      }
                    }))
          ],
        ));
  });
}
