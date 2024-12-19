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

  void registerUser() async {
    final Map<String, dynamic> params = {
      "username": usernameController.text,
      "password": passwordController.text,
      "rightsLevel": 1,
    };

    final response = await http.post(
        Uri.parse('https://localhost:5000/newUser'),
        body: json.encode(params));
    Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
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
            const Text(
              "Username",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0)),
              ),
            ),
            const Text("Password",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0)),
              ),
            ),
            ElevatedButton(onPressed: registerUser, child: const Text("Save")),
            ElevatedButton(
              onPressed: registerUser,
              child: const Align(
                alignment: Alignment.bottomRight,
                child: Text("Registration for admin",
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
