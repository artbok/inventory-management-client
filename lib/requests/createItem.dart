import 'dart:convert';
import 'package:http/http.dart' as http;
import '../localStorage.dart';


void createItem(String name, String description, String amount) async {
  String? username = getValue("username");
  String? password = getValue("password");
  Map<String, dynamic> params = {
    "username": username,
    "password": password,
    "name": name,
    "description": description,
    "amount": amount,
  };
  var response = await http.post(
    Uri.parse('http://127.0.0.1:5000/newItem'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(params),
  );
}
