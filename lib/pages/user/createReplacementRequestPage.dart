import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../requests/createReplacementRequest.dart';
import '../../localStorage.dart';
import '../../widgets/showIncorrectDataAlert.dart';

Widget createReplacementRequestPage(String itemName, int maxQuantity) {
  TextEditingController controller = TextEditingController();
  String? errorText;
  return StatefulBuilder(builder: (context, setState) {
    return Dialog(
      child: Column(
        children: [
          const Expanded(
              child: Text(
            "How many items do you want to repair?",
            style: TextStyle(fontSize: 40),
          )),
          Expanded(
              flex: 1,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
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
                    if (number == null || number < 1 || number > maxQuantity) {
                      setState(() {
                        errorText =
                            'Please enter a number between 1 and $maxQuantity';
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel")),
                ElevatedButton(
                    onPressed: () async {
                      if (errorText == null) {
                        String owner = getValue("username");
                        Navigator.pop(context);
                        await createReplacementRequest(
                            owner, itemName, int.parse(controller.text));
                      } else {
                        showIncorrectDataAlert(context);
                      }
                    },
                    child: const Text("Request")),
              ],
            ),
          )
        ],
      ),
    );
  });
}
