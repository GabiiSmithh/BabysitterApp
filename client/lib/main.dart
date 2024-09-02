import 'package:client/babysitter-register/screen.dart';
import 'package:client/common/api_service.dart';
import 'package:client/babysitter-services/screen.dart';
import 'package:client/profile/screen.dart';
import 'package:client/tutor-services/screen.dart';
import 'package:flutter/material.dart';
import 'package:client/home.dart'; 
import 'package:client/babysitting-services/list_services_screen.dart'; 
import 'package:client/babysitting-services/create_service_screen.dart'; 

void main() {
  ApiService.initialize('http://201.23.18.202:3333');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Babysitter App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(), // Tela inicial
      routes: {
        '/services': (context) => const CreateServicePage(),
        '/login': (context) => const HomeScreen(), 
        '/cadastro': (context) => const BabysitterSignUpPage(), 
        '/profile': (context) => const ProfileScreen(), 
        '/requests': (context) => const BabysittingRequestsPage(),
        '/my-services':(context) => const TutorServicesScreen(),
        '/services-provided':(context) => const BabysitterServicesScreen(),
      },
    );
  }
}
