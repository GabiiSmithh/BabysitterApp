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
  List<BabysittingService> requests = [];

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    try {
      final data = await BabySittingService.getBabySittingServiceList();

      setState(() {
        requests = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load requests')),
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
                      .pushNamed('/profile'); // Navega para a página de perfil
                  break;
                case 'services':
                  Navigator.of(context).pushNamed('/services');
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
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 4.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.pink[100], // Tom de rosa claro
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                request.tutorId,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.child_care,
                                    color: Colors.pinkAccent),
                                SizedBox(width: 8.0),
                                Text(
                                  '${request.childrenCount} Crianças',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    color: Colors.pinkAccent),
                                SizedBox(width: 8.0),
                                Text(
                                  'Início: ${_formatDateTime(request.startDate)}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              children: [
                                Icon(Icons.calendar_today_outlined,
                                    color: Colors.pinkAccent),
                                SizedBox(width: 8.0),
                                Text(
                                  'Término: ${_formatDateTime(request.endDate)}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: () {
                                // Handle accepting the request
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Solicitação Aceita')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 182, 46, 92),
                                padding: EdgeInsets.symmetric(
                                    vertical: 14.0, horizontal: 24.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: Text(
                                'Candidatar-se',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} às ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
