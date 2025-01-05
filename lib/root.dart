import 'package:flutter/material.dart';
import 'pages/registrationPage.dart';
import 'pages/storagePage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InventoryManagement',
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const StoragePage(),
    );
  }
}
