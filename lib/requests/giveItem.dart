import 'dart:convert';
import 'package:http/http.dart' as http;
import '../localStorage.dart';

Future<String> giveItem(String user, String itemName, String description, int quantity) async {
  String? username = getValue("username");
  String? password = getValue("password");
  Map<String, dynamic> params = {
    "username": username,
    "password": password,
    "user": user,
    "itemName": itemName,
    "description": description,
    "quantity": quantity,
  };
  var response = await http.post(
    Uri.parse('http://127.0.0.1:5000/giveItem'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(params),
  );

  Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
  return data["status"];
}
