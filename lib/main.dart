import 'package:flutter/material.dart';
import 'root.dart';
import 'package:hive_flutter/adapters.dart';
import 'localStorage.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("storage");
  putToTheStorage("username", "bebrobruh");
  //putToTheStorage("username", "bebra");
  putToTheStorage("password", "12345");
  runApp(const MyApp());
}
