import 'package:flutter/material.dart';
import 'package:predprof/requests/loginUser.dart';
import 'pages/authorisationPage.dart';
import 'pages/userStoragePage.dart';
import 'localStorage.dart';
import 'pages/storagePage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> checkAuth() async {
    String username = getValue("username");
    String password = getValue("password");
    if (username.isNotEmpty && password.isNotEmpty) {
      Map<String, dynamic> data = await loginUser(username, password);
      if (data["status"] == 'ok') {
        if (data["rightsLevel"] == 1) {
          return const UserStoragePage();
        } else {
          return const StoragePage();
        }
      }
    }
    return const LoginPage();
  }
  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        title: 'InventoryManagement',
        theme: ThemeData(
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
            future: checkAuth(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } {
                return snapshot.data!;
              }
            },
      ));
  }
}
