import 'package:client/babysitter-services/components/babysitter_service_card.dart';
import 'package:client/common/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BabysitterServicesScreen extends StatefulWidget {
  const BabysitterServicesScreen({super.key});

  @override
  _BabysitterServicesScreenState createState() =>
      _BabysitterServicesScreenState();
}

class _BabysitterServicesScreenState extends State<BabysitterServicesScreen> {
  late Future<List<Map<String, dynamic>>> _servicesFuture;

  @override
  void initState() {
    super.initState();
    _servicesFuture = _fetchServices();
  }

  Future<List<Map<String, dynamic>>> _fetchServices() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    final response = await http.get(
        Uri.parse('http://201.23.18.202:3333/babysitters/${userId}/services'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((service) => service as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Serviços Prestados',
        onBackButtonPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _servicesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Falha ao carregar os dados'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Nenhum serviço prestado ainda.',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/requests');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent, 
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // Rounded corners
                      ),
                      elevation: 5.0, // Shadow effect
                    ),
                    child: const Text(
                      'Ver Solicitações',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            final services = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return BabysitterServiceCard(
                    tutorName: service['tutorName'],
                    childrenCount: service['childrenCount'],
                    startDate: DateTime.parse(service['startDate']),
                    endDate: DateTime.parse(service['endDate']),
                    address: service['address'],
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
