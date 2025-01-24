import 'dart:convert';
import 'package:http/http.dart' as http;
import '../localStorage.dart';

Future<String> editItem(
     String name, String description, String newName, String newDescription) async {
  String? username = getValue("username");
  String? password = getValue("password");
  Map<String, dynamic> params = {
    "username": username,
    "password": password,
    "name": name, 
    "description": description,
    "newName": newName,
    "newDescription": newDescription
  };
  var response = await http.post(
    Uri.parse('http://127.0.0.1:5000/editItem'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(params),
  );

  Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
  return data["status"];
}
