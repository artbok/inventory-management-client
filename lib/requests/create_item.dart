import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventory_managment/local_storage.dart';


Future<String> createItem(
    String name, String description, int quantity) async {
  String? username = getValue("username");
  String? password = getValue("password");
  Map<String, dynamic> params = {
    "username": username,
    "password": password,
    "name": name,
    "description": description,
    "quantity": quantity,
  };
  var response = await http.post(
    Uri.parse('http://127.0.0.1:5000/newItem'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(params),
  );
  Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
  return data["status"];
}
