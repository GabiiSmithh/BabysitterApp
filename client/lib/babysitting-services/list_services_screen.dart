import 'package:flutter/material.dart';

class BabysittingRequestsPage extends StatefulWidget {
  @override
  _BabysittingRequestsPageState createState() =>
      _BabysittingRequestsPageState();
}

class _BabysittingRequestsPageState extends State<BabysittingRequestsPage> {
  final List<BabysittingRequest> requests = [
    BabysittingRequest(
      tutorName: 'Joao Teste',
      numberOfChildren: 2,
      startDate: DateTime(2024, 8, 14, 9, 0),
      endDate: DateTime(2024, 8, 14, 17, 0),
    ),
    BabysittingRequest(
      tutorName: 'Joao Teste 2',
      numberOfChildren: 1,
      startDate: DateTime(2024, 8, 15, 8, 30),
      endDate: DateTime(2024, 8, 15, 12, 30),
    ),
    BabysittingRequest(
      tutorName: 'Alice Maria',
      numberOfChildren: 3,
      startDate: DateTime(2024, 8, 16, 14, 0),
      endDate: DateTime(2024, 8, 16, 20, 0),
    ),
  ];

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
      body: Padding(
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
                      request.tutorName,
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
                          '${request.numberOfChildren} Crianças',
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
                        Icon(Icons.calendar_today, color: Colors.pinkAccent),
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
                            backgroundColor: Color.fromARGB(255, 182, 46, 92),
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
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} às ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class BabysittingRequest {
  final String tutorName;
  final int numberOfChildren;
  final DateTime startDate;
  final DateTime endDate;

  BabysittingRequest({
    required this.tutorName,
    required this.numberOfChildren,
    required this.startDate,
    required this.endDate,
  });
}
