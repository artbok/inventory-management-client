import 'package:flutter/material.dart';

Widget elButton(Widget child, VoidCallback? func) {
  return ElevatedButton(
      onPressed: func,
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 147, 112, 219),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      child: child);
}
