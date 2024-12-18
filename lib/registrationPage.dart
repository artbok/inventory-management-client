import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String problem = "";

  void registerUser() async {
    Map<String, dynamic> params = {
      "username": usernameController.text,
      "password": passwordController.text,
      "rightsLevel": "1",
    };
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/newUser'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: params,
    );
    Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
    setState(() {
      problem = data["description"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Username"),
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
              ),
            ),
            const Text("Password"),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
              ),
            ),
            ElevatedButton(onPressed: registerUser, child: const Text("Save")),
            Text(problem)
          ],
        ),
      ),
    );
  }
}
