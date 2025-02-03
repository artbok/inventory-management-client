import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventory_managment/local_storage.dart';


Future<String> createItemRequest(int? itemId, String itemName, String itemDescription, int itemQuantity) async {
  String? username = getValue("username");
  String? password = getValue("password");
  Map<String, dynamic> params = {
    "username": username,
    "password": password,
    "itemId": itemId,
    "itemName": itemName,
    "itemDescription": itemDescription,
    "itemQuantity": itemQuantity,
  };
  final Uri url = Uri.parse('${getValue("serverAddress")}/newItemRequest');
  var response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(params),
  );

  Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
  return data["status"];
}
