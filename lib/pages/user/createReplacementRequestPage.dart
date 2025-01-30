import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../requests/createReplacementRequest.dart';
import '../../localStorage.dart';
import '../../widgets/showIncorrectDataAlert.dart';

Widget createReplacementRequestPage(int itemId, String itemName, String description,
    int maxQuantity, VoidCallback refreshPage) {
  TextEditingController controller = TextEditingController();
  String? errorText;
  return StatefulBuilder(builder: (context, setState) {
    return Dialog(
      child: Column(
        children: [
          const Expanded(
              child: Text(
            "Сколько предметов вы хотите запросить на починку?",
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
                    labelText: 'количество предметов',
                    errorText: errorText,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    final int? number = int.tryParse(value);
                    if (number == null || number < 1 || number > maxQuantity) {
                      setState(() {
                        errorText =
                            'Пожалуйста введите число от 1 до $maxQuantity';
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
                    child: const Text("Отмена")),
                ElevatedButton(
                    onPressed: () async {
                      if (errorText == null) {
                        String owner = getValue("username");
                        Navigator.pop(context);
                        await createReplacementRequest(owner, itemId,
                            int.parse(controller.text));
                        refreshPage();
                      } else {
                        showIncorrectDataAlert(context);
                      }
                    },
                    child: const Text("Запрос")),
              ],
            ),
          )
        ],
      ),
    );
  });
}
