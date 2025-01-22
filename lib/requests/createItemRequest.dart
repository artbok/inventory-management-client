import 'dart:convert';
import 'package:http/http.dart' as http;
import '../localStorage.dart';

Future<String> createItemRequest(bool isCustom, String itemName, int quantity, String owner) async {
  String? username = getValue("username");
  String? password = getValue("password");
  Map<String, dynamic> params = {
    "username": username,
    "password": password,
    "isCustom": isCustom,
    "itemName": itemName,
    "quantity": quantity,
    "owner": owner
  };
  var response = await http.post(
    Uri.parse('http://127.0.0.1:5000/newItemRequest'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(params),
  );

  Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
  return data["status"];
}
