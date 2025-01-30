import 'package:flutter/material.dart';

Widget background(Widget child) {
  return Container(
      decoration: const BoxDecoration(
      gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: <Color>[
        Color.fromARGB(255, 57, 126, 160),
        Color.fromARGB(255, 93, 126, 160),
        Color.fromARGB(150, 93, 126, 160),
        Color.fromARGB(100, 48, 126, 160),
        Color.fromARGB(100, 48, 126, 160),
        Color.fromARGB(150, 93, 126, 160),
        Color.fromARGB(255, 93, 126, 160),
        Color.fromARGB(255, 57, 126, 160),
  ],
  tileMode: TileMode.clamp),
  ), child: child);
}
