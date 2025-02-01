import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventory_managment/local_storage.dart';


Future<String> editItem(int itemId,
     String name, String description, String newName, int newQuantity, String newDescription) async {
  String? username = getValue("username");
  String? password = getValue("password");
  Map<String, dynamic> params = {
    "username": username,
    "password": password,
    "name": name, 
    "description": description,
    "newName": newName,
    "newQuantity": newQuantity,
    "newDescription": newDescription,
    "itemId": itemId
  };
  var response = await http.post(
    Uri.parse('http://127.0.0.1:5000/editItem'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(params),
  );

  Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
  return data["status"];
}
