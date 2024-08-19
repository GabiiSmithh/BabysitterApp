import 'package:flutter/material.dart';
import 'package:client/home.dart'; //login
import 'package:client/babysitter/screen.dart'; //cadastro de babá
import 'package:client/babysitting-services/list_services_screen.dart'; // Lista de serviços criados
import 'package:client/babysitting-services/create_service_screen.dart'; // Criar um serviço
import 'package:client/babysitter/babysitter_profile.dart'; // Perfil da babá

void main() {
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
        '/services': (context) => CreateServicePage(), // Rota para a tela de criar serviço
        '/login': (context) => HomeScreen(), // Rota para a tela de login
        '/cadastro': (context) => BabysitterSignUpPage(), // Rota para a tela de cadastro
        '/profile': (context) => BabysitterProfilePage(), // Rota para a tela de perfil da babá
        '/requests': (context) => BabysittingRequestsPage(), // Rota para a tela de solicitações
      },
    );
  }
}
