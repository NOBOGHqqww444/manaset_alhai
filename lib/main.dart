import 'package:flutter/material.dart';
import 'login.dart';
import 'login.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'منصة الحي',
      theme: ThemeData(
        primaryColor: Color(0xFF2E7D32),
        primarySwatch: Colors.green,
        //accentColor: Color(0xFF4CAF50),
        fontFamily: 'Tajawal',
        scaffoldBackgroundColor: Colors.white,
      ),
      home:LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}