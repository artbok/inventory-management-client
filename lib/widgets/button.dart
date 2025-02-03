import 'package:flutter/material.dart';

Widget elButton(Widget child, VoidCallback func) {
  return ElevatedButton(child: child,  onPressed: () => func, style:  ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 243, 175, 150)));


}
