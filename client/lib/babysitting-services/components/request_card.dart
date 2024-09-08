import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestCard extends StatefulWidget {
  final String tutorName;
  final int childrenCount;
  final DateTime startDate;
  final DateTime endDate;
  final VoidCallback onAccept;
  final String tutorId;
  final String? id;
  final int? value;
  final String? address;

  const RequestCard({
    super.key,
    required this.tutorName,
    required this.childrenCount,
    required this.startDate,
    required this.endDate,
    required this.onAccept,
    required this.tutorId,
    this.id,
    this.value,
    this.address,
  });

  @override
  _RequestCardState createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  String? _loggedUserId;
  bool _isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    _loadLoggedUserId();
  }

  Future<void> _loadLoggedUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _loggedUserId = prefs.getString('user_id');
      _isButtonDisabled = widget.tutorId == _loggedUserId;
    });
  }

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
                      const Icon(Icons.child_care, color: Colors.pinkAccent),
                      const SizedBox(width: 8.0),
                      Text(
                        '${widget.childrenCount} Crianças',
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          color: Colors.pinkAccent),
                      const SizedBox(width: 8.0),
                      Text(
                        'Início: ${_formatDateTime(widget.startDate)}',
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          color: Colors.pinkAccent),
                      const SizedBox(width: 8.0),
                      Text(
                        'Término: ${_formatDateTime(widget.endDate)}',
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      const Icon(Icons.monetization_on,
                          color: Colors.pinkAccent),
                      const SizedBox(width: 8.0),
                      Text(
                        'Valor: R\$ ${widget.value}',
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.pinkAccent),
                      const SizedBox(width: 8.0),
                      Text(
                        'Responsável: ${widget.tutorName}',
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(Icons.location_pin, color: Colors.pinkAccent),
                      const SizedBox(width: 8.0),
                      Text(
                        'Endereço: ${widget.address}',
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _isButtonDisabled ? null : widget.onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 182, 46, 92),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 24.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
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
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} às ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
