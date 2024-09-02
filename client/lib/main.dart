import 'package:client/babysitter-register/screen.dart';
import 'package:client/common/api_service.dart';
import 'package:client/profile/babysitter_screen.dart';
import 'package:client/babysitter-services/screen.dart';
import 'package:client/profile/become_tutor_screen.dart';
import 'package:client/profile/tutor_screen.dart';
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
        '/babysitter-profile':(context) => const BabysitterProfileScreen(),
        '/tutor-profile': (context) => const TutorProfileScreen(),
        '/login': (context) => const HomeScreen(), 
        '/cadastro': (context) => const BabysitterSignUpPage(), 
        '/requests': (context) => const BabysittingRequestsPage(),
        '/my-services':(context) => const TutorServicesScreen(),
        '/services-provided':(context) => const BabysitterServicesScreen(),
        '/become-tutor':(context) => const BecomeTutorScreen(),
      },
    );
  }
}
