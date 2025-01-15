import 'dart:convert';
import 'package:http/http.dart' as http;
import '../localStorage.dart';

Future<String> createReplacementRequest(
    String owner, String itemName, int amount) async {
  String? username = getValue("username");
  String? password = getValue("password");
  Map<String, dynamic> params = {
    "username": username,
    "password": password,
    "owner": owner,
    "itemName": itemName,
    "amount": amount
    
  };
  var response = await http.post(
    Uri.parse('http://127.0.0.1:5000/newReplacementRequest'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(params),
  );

  Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
  return data["status"];
}
