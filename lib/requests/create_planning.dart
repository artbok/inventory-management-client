import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventory_managment/local_storage.dart';


Future<Map<String, dynamic>> createPlanning(
    String itemName, String itemDescription, int itemQuantity, String supplier, int price) async {
  String? username = getValue("username");
  String? password = getValue("password");
  Map<String, dynamic> params = {
    "username": username,
    "password": password,
    "itemName": itemName,
    "itemDescription": itemDescription,
    "itemQuantity": itemQuantity,
    "supplier": supplier,
    "price": price
  };
  final Uri url = Uri.parse('${getValue("serverAddress")}/newPlaning');
  var response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(params),
  );

  Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
  return data;
}
