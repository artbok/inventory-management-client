import 'package:flutter/material.dart';
import 'root.dart';
import 'package:hive_flutter/adapters.dart';
import 'localStorage.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("storage");
  // putToTheStorage('username', 'bebra');
  // print(getValue('username'));
  runApp(const MyApp());
}
