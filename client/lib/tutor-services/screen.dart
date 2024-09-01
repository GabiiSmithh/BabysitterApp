import 'package:client/common/app_bar.dart';
import 'package:client/my-services/components/my_service_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class TutorServicesScreen extends StatefulWidget {
  const TutorServicesScreen({super.key});

  @override
  _TutorServicesScreenState createState() => _TutorServicesScreenState();
}

class _TutorServicesScreenState extends State<TutorServicesScreen> {
  late Future<List<Map<String, dynamic>>> _servicesFuture;

  Future<Map<String, String?>> getUserCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    String? userId = prefs.getString('user_id');
    
    return {'user_id': userId};
  }

 //Future<Map<String, dynamic>> tutor= {};

  @override
  void initState() {
    super.initState();
    _servicesFuture = _fetchTutorServices();
  }

  Future<List<Map<String, dynamic>>> _fetchTutorServices() async {
    Map<String, String?> credentials = await getUserCredentials();
    final response =
        await http.get(Uri.parse('http://201.23.18.202:3333/tutors/${credentials['user_id']}/services'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((service) => service as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

Future<Map<String, dynamic>> _fetchTutor() async {
  Map<String, String?> credentials = await getUserCredentials();
  final url = Uri.parse('http://201.23.18.202:3333/tutors/${credentials['user_id']}');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // Decodifique a resposta JSON para um Map<String, dynamic>
    Map<String, dynamic> tutor = json.decode(response.body);
    return tutor;
  } else {
    throw Exception('Failed to load tutor');
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: CustomAppBar(
      title: 'Meus Serviços',
      onBackButtonPressed: () {
        Navigator.of(context).pop();
      },
    ),
    body: FutureBuilder<Map<String, dynamic>>(
      future: _fetchTutor(),
      builder: (context, tutorSnapshot) {
        if (tutorSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (tutorSnapshot.hasError) {
          return const Center(child: Text('Failed to load tutor'));
        } else if (!tutorSnapshot.hasData) {
          return const Center(child: Text('Tutor data not available'));
        } else {
          final tutor = tutorSnapshot.data!;

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _servicesFuture,
            builder: (context, servicesSnapshot) {
              if (servicesSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (servicesSnapshot.hasError) {
                return const Center(child: Text('Failed to load services'));
              } else if (!servicesSnapshot.hasData || servicesSnapshot.data!.isEmpty) {
                return const Center(child: Text('No services available'));
              } else {
                final services = servicesSnapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];
                      return MyServiceCard(
                        tutorName: tutor['name'], // Usando o nome do tutor aqui
                        childrenCount: service['childrenCount'],
                        startDate: DateTime.parse(service['startDate']),
                        endDate: DateTime.parse(service['endDate']),
                        address: service['address'],
                        babysitterId: null,
                        onAccept: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Solicitação Aceita')),
                          );
                        },
                        onSave: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Serviço Atualizado')),
                          );
                        },
                      );
                    },
                  ),
                );
              }
            },
          );
        }
      },
    ),
  );
}
}
