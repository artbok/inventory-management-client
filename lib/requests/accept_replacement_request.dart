import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventory_managment/local_storage.dart';


Future<Map<String, dynamic>> acceptReplacementRequest(int id) async {
  String? username = getValue("username");
  String? password = getValue("password");
  Map<String, dynamic> params = {
    "username": username,
    "password": password,
    "id": id
  };
  final Uri url = Uri.parse('${getValue("serverAddress")}/acceptReplacementRequest');

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
