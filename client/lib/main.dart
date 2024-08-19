// import 'package:app/login_screen.dart';
import 'package:client/common/api_service.dart';
import 'package:client/home.dart';
import 'package:flutter/material.dart';

void main() {
  ApiService.initialize('http://localhost:3000');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[300],
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
        useMaterial3: true,
      ),
      home:  HomeScreen(),
      routes: {"/home": (context) => HomeScreen()} ,
    );
  }
}