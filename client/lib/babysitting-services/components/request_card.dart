import 'package:flutter/material.dart';

class RequestCard extends StatelessWidget {
  final String tutorName;
  final int childrenCount;
  final DateTime startDate;
  final DateTime endDate;
  final VoidCallback onAccept;
  final String? id;
  final String? babysitterId;
  final String? tutorId;
  final int? value;
  final String? address;

  RequestCard({
    required this.tutorName,
    required this.childrenCount,
    required this.startDate,
    required this.endDate,
    required this.onAccept,
    this.id,
    this.babysitterId,
    this.tutorId,
    this.value,
    this.address,
  });

  @override
  Widget build(BuildContext context) {
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.child_care, color: Colors.pinkAccent),
                      SizedBox(width: 8.0),
                      Text(
                        '$childrenCount Crianças',
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
                      Icon(Icons.calendar_today, color: Colors.pinkAccent),
                      SizedBox(width: 8.0),
                      Text(
                        'Início: ${_formatDateTime(startDate)}',
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
                        'Término: ${_formatDateTime(endDate)}',
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
                      Icon(Icons.monetization_on, color: Colors.pinkAccent),
                      SizedBox(width: 8.0),
                      Text(
                        'Valor: R\$ $value',
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
                      Icon(Icons.person, color: Colors.pinkAccent),
                      SizedBox(width: 8.0),
                      Text(
                        'Tutor ID: $tutorId',
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
                      Icon(Icons.person_pin, color: Colors.pinkAccent),
                      SizedBox(width: 8.0),
                      Text(
                        'Babysitter ID: $babysitterId',
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
                      Icon(Icons.location_pin, color: Colors.pinkAccent),
                      SizedBox(width: 8.0),
                      Text(
                        'Endereço: $address',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 182, 46, 92),
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
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
