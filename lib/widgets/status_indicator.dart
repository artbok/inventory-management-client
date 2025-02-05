import 'package:flutter/material.dart';

Widget statusIndicator(String status) {
  Map<String, LinearGradient> gradients = {
    "Новый": const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Color.fromARGB(255, 9, 235, 58),
                  Color.fromARGB(255, 17, 161, 61),
                ],
                tileMode: TileMode.clamp),
    "Использованный": const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Color.fromARGB(255, 9, 235, 186),
                  Color.fromARGB(255, 11, 218, 255),
                ],
                tileMode: TileMode.clamp),
    "Сломанный": const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
                  Color.fromARGB(255, 235, 9, 9),
                  Color.fromARGB(255, 255, 60, 11),
        ],
        tileMode: TileMode.clamp),
  };
  return Container(
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      gradient: gradients[status],
      borderRadius: BorderRadius.circular(20)),
    child: Text(status, style: const TextStyle(color: Colors.white)),
  );
}
