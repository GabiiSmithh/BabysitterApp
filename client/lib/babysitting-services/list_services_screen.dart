import 'package:client/babysitting-services/components/request_card.dart';
import 'package:client/babysitting-services/model.dart';
import 'package:client/babysitting-services/service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BabysittingRequestsPage extends StatefulWidget {
  @override
  _BabysittingRequestsPageState createState() =>
      _BabysittingRequestsPageState();
}

class _BabysittingRequestsPageState extends State<BabysittingRequestsPage> {
  List<BabysittingService> services = [];

  @override
  void initState() {
    super.initState();
    getServices();
  }

  Future<void> getServices() async {
    try {
      final data = await BabySittingService.getBabySittingServiceList();

      setState(() {
        services = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load services')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 215, 229),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 182, 46, 92),
        title: Text(
          'Serviços Disponíveis',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          PopupMenuButton<String>(
            // Adiciona um menu suspenso à AppBar
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person,
                  color: Color.fromARGB(255, 235, 29, 98), size: 24.0),
            ),
            onSelected: (String value) {
              switch (value) {
                case 'profile':
                  Navigator.of(context)
                      .pushNamed('/profile'); 
                  break;
                case 'services':
                  Navigator.of(context).pushNamed('/my-services');
                  break;
                case 'settings':
                  Navigator.of(context).pushNamed('/settings');
                  break;
                case 'logout':
                  Navigator.of(context).pushNamed('/login');
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'profile',
                  child: ListTile(
                    leading: Icon(Icons.person,
                        color: Color.fromARGB(255, 182, 46, 92)),
                    title: Text('Seu perfil'),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'services',
                  child: ListTile(
                    leading: Icon(Icons.history,
                        color: Color.fromARGB(255, 182, 46, 92)),
                    title: Text('Serviços já prestados'),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'settings',
                  child: ListTile(
                    leading: Icon(Icons.settings,
                        color: Color.fromARGB(255, 182, 46, 92)),
                    title: Text('Configurações da conta'),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: ListTile(
                    leading: Icon(Icons.logout,
                        color: Color.fromARGB(255, 182, 46, 92)),
                    title: Text('Sair da conta'),
                  ),
                ),
              ];
            },
          ),
          SizedBox(
              width: 16.0), // Espaço extra para não sobrepor a faixa de debug
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              final request = services[index];
              return RequestCard(
                tutorName: request.tutorId,
                childrenCount: request.childrenCount,
                startDate: request.startDate,
                endDate: request.endDate,
                address: request.address,
                value: request.value.toInt(),
                id: request.id,
                onAccept: () => {print("Aceitado")},
              );
            },
          )),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} às ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
