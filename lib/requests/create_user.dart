import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> createUser(String username, String password, int rightsLevel) async {
  Map<String, dynamic> params = {
    "username": username,
    "password": password,
    "rightsLevel": rightsLevel
  };
  final response = await http.post(
    Uri.parse('http://127.0.0.1:5000/newUser'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: json.encode(params),
  );
  Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
  return data;
}
