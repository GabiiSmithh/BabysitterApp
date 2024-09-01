import 'package:client/babysitter-register/screen.dart';
import 'package:client/common/api_service.dart';
import 'package:client/my-services/screen.dart';
import 'package:client/profile/babysitter_edit.dart';
import 'package:client/profile/babysitter_screen.dart';
import 'package:client/profile/tutor_edit.dart';
import 'package:flutter/material.dart';
import 'package:client/home.dart'; 
import 'package:client/babysitting-services/list_services_screen.dart'; 
import 'package:client/babysitting-services/create_service_screen.dart'; 

void main() {
  ApiService.initialize('http://201.23.18.202:3333');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Babysitter App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(), // Tela inicial
      routes: {
        '/services': (context) => CreateServicePage(), 
        '/login': (context) => HomeScreen(), 
        '/cadastro': (context) => BabysitterSignUpPage(), 
        '/profile': (context) => ProfileScreen(), 
        '/requests': (context) => BabysittingRequestsPage(),
        '/my-services':(context) => MyServicesScreen(),
        '/babysitter_edit':(context) => BabysitterEditScreen(),
        '/tutor_edit': (context) => TutorEditScreen(),
      },
    );
  }
}
