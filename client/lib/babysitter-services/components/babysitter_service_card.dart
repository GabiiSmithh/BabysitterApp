import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class BabysitterServiceCard extends StatefulWidget {
  final String tutorName;
  final int childrenCount;
  final DateTime startDate;
  final DateTime endDate;
  final String address;

  const BabysitterServiceCard({
    super.key,
    required this.tutorName,
    required this.childrenCount,
    required this.startDate,
    required this.endDate,
    required this.address,
  });

  @override
  _BabysitterServiceCardState createState() => _BabysitterServiceCardState();
}

class _BabysitterServiceCardState extends State<BabysitterServiceCard> {
  late TextEditingController _childrenCountController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _childrenCountController =
        TextEditingController(text: widget.childrenCount.toString());
    _startDateController = TextEditingController(
        text: DateFormat.yMMMd().format(widget.startDate));
    _endDateController =
        TextEditingController(text: DateFormat.yMMMd().format(widget.endDate));
    _addressController = TextEditingController(text: widget.address);
  }

  bool get _isConcluded => DateTime.now().isAfter(widget.endDate);

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
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: _isConcluded ? Colors.green[100] : Colors.orange[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.tutorName,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: _isConcluded ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      _isConcluded ? 'Concluído' : 'Pendente',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
                  _buildNonEditableField(
                    icon: Icons.child_care,
                    label: 'Quantidade de Crianças',
                    value: _childrenCountController.text,
                  ),
                  const SizedBox(height: 8.0),
                  _buildNonEditableField(
                    icon: Icons.calendar_today,
                    label: 'Data de Início',
                    value: _startDateController.text,
                  ),
                  const SizedBox(height: 8.0),
                  _buildNonEditableField(
                    icon: Icons.calendar_today_outlined,
                    label: 'Data de Fim',
                    value: _endDateController.text,
                  ),
                  const SizedBox(height: 8.0),
                  _buildNonEditableField(
                    icon: Icons.location_on,
                    label: 'Endereço',
                    value: _addressController.text,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNonEditableField({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.pinkAccent),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            '$label: $value',
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _childrenCountController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
