import 'package:client/babysitting-services/create_service_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BabysittingRequestsPage extends StatefulWidget {
  @override
  _BabysittingRequestsPageState createState() =>
      _BabysittingRequestsPageState();
}

class _BabysittingRequestsPageState extends State<BabysittingRequestsPage> {
  List<BabysittingRequest> requests = [];

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    final url = Uri.parse('http://201.23.18.202:3333/services');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        requests = data.map((json) => BabysittingRequest.fromJson(json)).toList();
      });
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load requests')),
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
      ),
      body: requests.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 4.0,
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tutor ID: ${request.tutorId}',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: 1.0,
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            children: [
                              Icon(Icons.child_care, color: Colors.pinkAccent),
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
                          SizedBox(height: 12.0),
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
                          SizedBox(height: 8.0),
                          Row(
                            children: [
                              Icon(Icons.home, color: Colors.pinkAccent),
                              SizedBox(width: 8.0),
                              Text(
                                'Endereço: ${request.address}',
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
                              Icon(Icons.attach_money, color: Colors.pinkAccent),
                              SizedBox(width: 8.0),
                              Text(
                                'Valor: R\$${request.value}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            children: [
                              Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  // Handle accepting the request
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Request Accepted')),
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
                                  'Aceitar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateServicePage()),
          );
        },
        backgroundColor: Color.fromARGB(255, 182, 46, 92),
        child: Icon(Icons.add),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} às ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class BabysittingRequest {
  final String id;
  final String? babysitterId;
  final String tutorId;
  final DateTime startDate;
  final DateTime endDate;
  final double value;
  final int childrenCount;
  final String address;

  BabysittingRequest({
    required this.id,
    this.babysitterId,
    required this.tutorId,
    required this.startDate,
    required this.endDate,
    required this.value,
    required this.childrenCount,
    required this.address,
  });

  factory BabysittingRequest.fromJson(Map<String, dynamic> json) {
    return BabysittingRequest(
      id: json['id'],
      babysitterId: json['babysitterId'],
      tutorId: json['tutorId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      value: json['value'].toDouble(),
      childrenCount: json['childrenCount'],
      address: json['address'],
    );
  }
}
