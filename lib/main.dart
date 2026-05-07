import 'package:flutter/material.dart';
import 'package:smart_library/screens/main_screen.dart';
import 'screens/home_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'smart library',
       theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),

      home:  const MainScreen(),
    );
  }
}



