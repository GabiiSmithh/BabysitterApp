
import 'package:client/my-services/components/my_service_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class MyServicesScreen extends StatefulWidget {
  @override
  _MyServicesScreenState createState() => _MyServicesScreenState();
}

class _MyServicesScreenState extends State<MyServicesScreen> {
  late Future<List<Map<String, dynamic>>> _servicesFuture;

  @override
  void initState() {
    super.initState();
    _servicesFuture = _fetchServices();
  }

  Future<List<Map<String, dynamic>>> _fetchServices() async {
    final response = await http.get(Uri.parse('http://201.23.18.202:3333/services'));

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
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 182, 46, 92),
        title: Text(
          'Meus Serviços',
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
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _servicesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load services'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No services available'));
          } else {
            final services = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return MyServiceCard(
                    tutorName: "service['tutorName']",
                    childrenCount: service['childrenCount'],
                    startDate: DateTime.parse(service['startDate']),
                    endDate: DateTime.parse(service['endDate']),
                    address: service['address'],
                    babysitterId: null,
                    onAccept: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Solicitação Aceita')),
                      );
                    },
                    onSave: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Serviço Atualizado')),
                      );
                    },
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
