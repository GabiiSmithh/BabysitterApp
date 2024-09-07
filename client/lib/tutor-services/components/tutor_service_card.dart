import 'package:flutter/material.dart';

import '../../babysitting-services/service.dart';

class TutorServiceCard extends StatefulWidget {
  final String tutorName;
  final int childrenCount;
  final DateTime startDate;
  final DateTime endDate;
  final String address;
  final String serviceId;
  final String? babysitterId;
  final String? babysitterName;
  final VoidCallback onAccept;
  final VoidCallback onSave;

  const TutorServiceCard({
    super.key,
    required this.tutorName,
    required this.childrenCount,
    required this.startDate,
    required this.endDate,
    required this.address,
    required this.serviceId,
    required this.babysitterId,
    required this.babysitterName,
    required this.onAccept,
    required this.onSave,
  });

  @override
  _TutorServiceCardState createState() => _TutorServiceCardState();
}

class _TutorServiceCardState extends State<TutorServiceCard> {
  bool _isEditing = false;
  late TextEditingController _childrenCountController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _addressController;

  Map<String, dynamic> formData = {
    'address': '',
    'children_count': '',
  };

  @override
  void initState() {
    super.initState();
    _childrenCountController =
        TextEditingController(text: widget.childrenCount.toString());
    _startDateController =
        TextEditingController(text: widget.startDate.toString());
    _endDateController = TextEditingController(text: widget.endDate.toString());
    _addressController = TextEditingController(text: widget.address);
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _editService() async {
    try {
      //   'start_date': '',
      // 'end_date': '',
      // 'value': 0,
      // 'children_count': 0,
      // 'address': ''
      formData["address"] = _addressController.text;
      formData["children_count"] = _childrenCountController.text;

      // _isEditing = !_isEditing;
      _toggleEdit();
      await BabySittingService.updateService(widget.serviceId, formData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Serviço editado com Sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao criar serviço: $e')),
      );
    }
  }

  bool get _isServiceDone {
    return DateTime.now().isAfter(widget.endDate);
  }

  bool get _hasBabysitter {
    return widget.babysitterId != null;
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
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.pink[100],
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
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (widget.babysitterId == null)
                    IconButton(
                      icon: Icon(
                        _isEditing ? Icons.check : Icons.edit,
                        color: Colors.pinkAccent,
                      ),
                      onPressed: _isEditing ? _editService : _toggleEdit,
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEditableField(
                    icon: Icons.child_care,
                    label: 'Quantidade de Crianças',
                    controller: _childrenCountController,
                    isEditing: _isEditing,
                  ),
                  const SizedBox(height: 8.0),
                  _buildNonEditableField(
                      icon: Icons.calendar_today,
                      label: 'Data de Início',
                      value: widget.startDate.toString()),
                  const SizedBox(height: 8.0),
                  _buildNonEditableField(
                      icon: Icons.calendar_today_outlined,
                      label: 'Data de Fim',
                      value: widget.endDate.toString()),
                  const SizedBox(height: 8.0),
                  _buildEditableField(
                    icon: Icons.location_on,
                    label: 'Endereço',
                    controller: _addressController,
                    isEditing: _isEditing,
                  ),
                  const SizedBox(height: 8.0),
                  _buildNonEditableField(
                    icon: Icons.person_outline,
                    label: 'Babá',
                    value: widget.babysitterName ?? 'Sem babá',
                    hasIndicator: true,
                    indicator:
                        _hasBabysitter ? Icons.check_circle : Icons.cancel,
                    indicatorColor: _hasBabysitter ? Colors.green : Colors.red,
                  ),
                  const SizedBox(height: 8.0),
                  _buildStatusIndicator(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required bool isEditing,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.pinkAccent),
        const SizedBox(width: 8.0),
        Expanded(
          child: isEditing
              ? TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: label,
                  ),
                )
              : Text(
                  '$label: ${controller.text}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black54,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildNonEditableField({
    required IconData icon,
    required String label,
    required String value,
    bool hasIndicator = false,
    IconData? indicator,
    Color? indicatorColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.pinkAccent),
        const SizedBox(width: 8.0),
        Expanded(
          child: Row(
            children: [
              Text(
                '$label: $value',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54,
                ),
              ),
              if (hasIndicator && indicator != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(indicator, color: indicatorColor),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Icon(
            _isServiceDone ? Icons.check_circle : Icons.pending,
            color: _isServiceDone ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 8.0),
          Text(
            _isServiceDone ? 'Concluído' : 'Pendente',
            style: TextStyle(
              fontSize: 16.0,
              color: _isServiceDone ? Colors.green : Colors.orange,
            ),
          ),
        ],
      ),
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
