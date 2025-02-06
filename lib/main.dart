import 'package:flutter/material.dart';
import 'package:inventory_managment/redirect_page.dart';

//must be deleted!
import 'package:hive_flutter/adapters.dart';
import 'package:inventory_managment/local_storage.dart';

const String serverAddress = "http://127.0.0.1:5000";
void main() async {
  //must be deleted!
  await Hive.initFlutter();
  await Hive.openBox("storage");
  putToTheStorage("serverAddress", serverAddress);
  //putToTheStorage("username", "bebrobruh");
  //putToTheStorage("username", "bebra");
//putToTheStorage("username", "bebra");
//putToTheStorage("password", "12345");

  runApp(const RedirectPage());
}
