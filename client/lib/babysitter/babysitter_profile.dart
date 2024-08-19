//página ta esquisita
//import 'package:flutter/material.dart';
//
//class BabysitterProfilePage extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        backgroundColor: Color.fromARGB(255, 182, 46, 92),
//        title: Text('Perfil da Babá'),
//        actions: [
//          IconButton(
//            icon: Icon(Icons.edit),
//            onPressed: () {
//              // Adicione a lógica para edição de perfil aqui
//            },
//          ),
//        ],
//      ),
//      body: Padding(
//        padding: const EdgeInsets.all(16.0),
//        child: Column(
//          children: [
//            // Foto de Perfil
//            CircleAvatar(
//              radius: 60.0,
//              backgroundImage: AssetImage('assets/images/babysitter_profile.jpg'), // Substitua pela imagem desejada
//              backgroundColor: Colors.grey[200],
//            ),
//            SizedBox(height: 16.0),
//            // Nome e Descrição
//            Text(
//              'Maria Silva',
//              style: TextStyle(
//                fontSize: 24.0,
//                fontWeight: FontWeight.bold,
//              ),
//            ),
//            SizedBox(height: 8.0),
//            Text(
//              'Babá experiente com 5 anos de atuação. Gosta de atividades educativas e recreativas com as crianças.',
//              style: TextStyle(
//                fontSize: 16.0,
//                color: Colors.black54,
//              ),
//              textAlign: TextAlign.center,
//            ),
//            SizedBox(height: 24.0),
//            // Informações Adicionais
//            Expanded(
//              child: ListView(
//                children: [
//                  ListTile(
//                    leading: Icon(Icons.phone, color: Color.fromARGB(255, 182, 46, 92)),
//                    title: Text('Telefone'),
//                    subtitle: Text('+55 11 99999-9999'),
//                  ),
//                  ListTile(
//                    leading: Icon(Icons.email, color: Color.fromARGB(255, 182, 46, 92)),
//                    title: Text('Email'),
//                    subtitle: Text('maria.silva@email.com'),
//                  ),
//                  ListTile(
//                    leading: Icon(Icons.location_on, color: Color.fromARGB(255, 182, 46, 92)),
//                    title: Text('Localização'),
//                    subtitle: Text('São Paulo, SP'),
//                  ),
//                  ListTile(
//                    leading: Icon(Icons.date_range, color: Color.fromARGB(255, 182, 46, 92)),
//                    title: Text('Data de Nascimento'),
//                    subtitle: Text('01/01/1985'),
//                  ),
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
//