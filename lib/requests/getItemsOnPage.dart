import 'dart:convert';
import 'package:http/http.dart' as http;
import '../localStorage.dart';

Future<Map<String, dynamic>> getItemsOnPage(int currentPage, [String? owner]) async {
  String? username = getValue("username");
  String? password = getValue("password");
  Map<String, dynamic> params = {
    "username": username,
    "password": password,
    "page": currentPage,
    "owner": owner
  };
  var response = await http.post(
    Uri.parse('http://127.0.0.1:5000/getItems'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(params),
  );

  Map<String, dynamic> data =
      jsonDecode(response.body) as Map<String, dynamic>;
  return data;
}
