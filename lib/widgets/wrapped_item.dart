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
                    Color.fromARGB(255, 249, 232, 236),
                    Color.fromARGB(255, 255, 208, 219),
                    Color.fromARGB(255, 225, 222, 234)
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
