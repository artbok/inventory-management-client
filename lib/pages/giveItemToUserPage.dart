import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../requests/giveItem.dart';

Widget giveItemToUser(String name, int quantityAtStorage, String description,
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
                      "Give $name to user",
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
                        hintText: 'Select user...',
                        border: const OutlineInputBorder(),
                        errorText:
                            !flag ? 'Please select a valid option' : null,
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
                      labelText: 'quantity of items',
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
                              'Please enter a number between 1 and $quantityAtStorage';
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
                    child: const Text("Submit"),
                    onPressed: () async {
                      if (flag && errorText == null) {
                        Navigator.pop(context);
                        await giveItem(controller1.text, name, description,
                            int.parse(controller2.text));
                        refreshPage();
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Provide correct data"),
                                actionsAlignment: MainAxisAlignment.center,
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("OK"))
                                ],
                              );
                            });
                      }
                    }))
          ],
        ));
  });
}
