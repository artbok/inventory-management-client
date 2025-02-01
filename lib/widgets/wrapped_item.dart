import 'package:flutter/material.dart';


Widget wrappedItem(Widget child) {
  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[
                  Color.fromARGB(255, 214, 195, 198),
                  Color.fromARGB(255, 235, 205, 197),
                  Color.fromARGB(255, 243, 175, 150),
                ],
                tileMode: TileMode.clamp),
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: child
          ));
}
