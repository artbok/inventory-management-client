import 'package:flutter/material.dart';
import 'package:inventory_managment/redirect_page.dart';

//must be deleted!
import 'package:hive_flutter/adapters.dart';
import 'package:inventory_managment/local_storage.dart';


void main() async {
  
  //must be deleted!
  await Hive.initFlutter();
  await Hive.openBox("storage");
  //putToTheStorage("username", "bebrobruh");
  putToTheStorage("username", "bebra");
  putToTheStorage("password", "12345");
  
  runApp(const RedirectPage());
}
