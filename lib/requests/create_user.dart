import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventory_managment/local_storage.dart';

Future<Map<String, dynamic>> createUser(
    String username, String password, int rightsLevel) async {
  Map<String, dynamic> params = {
    "username": username,
    "password": password,
    "rightsLevel": rightsLevel
  };
  final Uri url = Uri.parse('${getValue("serverAddress")}/newUser');
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: json.encode(params),
  );
  Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
  return data;
}
