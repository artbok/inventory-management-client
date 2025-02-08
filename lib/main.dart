import 'package:flutter/material.dart';
import 'package:inventory_managment/redirect_page.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:inventory_managment/local_storage.dart';

// const String serverAddress = "http://127.0.0.1:5000";
const String serverAddress = "http://server:5000";

String getServer() {
  return const String.fromEnvironment('SERVER_URL', defaultValue: serverAddress);
}

void main() async {
  String server = getServer();
  await Hive.initFlutter();
  await Hive.openBox("storage");
  putToTheStorage("serverAddress", server);
  // putToTheStorage("username", "bebrobruh");
  // putToTheStorage("username", "bebra");
  // putToTheStorage("password", "12345");

  runApp(const RedirectPage());
}
