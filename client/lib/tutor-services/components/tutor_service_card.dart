import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

import '../../babysitting-services/service.dart';

class TutorServiceCard extends StatefulWidget {
  final String tutorName;
  final int childrenCount;
  final double value;
  final DateTime startDate;
  final DateTime endDate;
  final String address;
  final String serviceId;
  final List<dynamic> enrollments;
  final String? babysitterId;
  final String? babysitterName;
  final VoidCallback onAccept;
  final VoidCallback onSave;

  const TutorServiceCard({
    super.key,
    required this.tutorName,
    required this.childrenCount,
    required this.value,
    required this.startDate,
    required this.endDate,
    required this.address,
    required this.serviceId,
    required this.babysitterId,
    required this.babysitterName,
    required this.enrollments,
    required this.onAccept,
    required this.onSave,
  });

  @override
  _TutorServiceCardState createState() => _TutorServiceCardState();

  
}

class _TutorServiceCardState extends State<TutorServiceCard> {
  bool _isEditing = false;
  late TextEditingController _childrenCountController;
  late DateTime _startDate;
  late DateTime _endDate;
  late TextEditingController _addressController;
  late TextEditingController _valueController;

  final _dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  @override
  void initState() {
    super.initState();
    _childrenCountController =
        TextEditingController(text: widget.childrenCount.toString());
    _startDate = widget.startDate;
    _endDate = widget.endDate;
    _addressController = TextEditingController(text: widget.address);
    _valueController = TextEditingController(text: widget.value.toString());
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

   void _acceptBabysitter (String babysitterId) async {
    try {
      await BabySittingService.acceptBabysitter(widget.serviceId, babysitterId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Serviço editado com sucesso!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao editar serviço: $e')),
      );
    }
  }

void _selectBabysitter() async {
  final String? selectedBabysitterId = await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Selecione uma Babá'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.enrollments.map((enrollment) {
            return ListTile(
              title: Text(enrollment['babysitterName'] ?? 'Sem nome'),
              onTap: () => Navigator.pop(context, enrollment['babysitterId']),  // Retorna o ID da babá
            );
          }).toList(),
        ),
      );
    },
  );

  if (selectedBabysitterId != null) {
    _acceptBabysitter(selectedBabysitterId); // Chama a função com o ID da babá selecionada
  }
}




  Future<void> _selectDateTime(BuildContext context, bool isStartDate) async {
    final DateTime initialDateTime = isStartDate ? _startDate : _endDate;

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDateTime),
      );

      if (selectedTime != null) {
        setState(() {
          final DateTime newDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );

          if (isStartDate) {
            _startDate = newDateTime;
          } else {
            _endDate = newDateTime;
          }
        });
      }
    }
  }

  void _editService() async {
    if (_startDate.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('A data de início não pode ser antes de hoje.')),
      );
      return;
    }

    if (_endDate.isBefore(_startDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'A data de término não pode ser antes da data de início.')),
      );
      return;
    }

    // Validate the children count
    int? childrenCount = int.tryParse(_childrenCountController.text);
    if (childrenCount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quantidade de crianças inválida.')),
      );
      return;
    }

    // Validate the value
    double? value = double.tryParse(_valueController.text);
    if (value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Valor inválido.')),
      );
      return;
    }

    final formData = {
      'address': _addressController.text,
      'children_count': childrenCount.toString(),
      'start_date': _dateTimeFormat.format(_startDate),
      'end_date': _dateTimeFormat.format(_endDate),
      'value': value.toString()
    };

    try {
      _toggleEdit();
      await BabySittingService.updateService(widget.serviceId, formData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Serviço editado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao editar serviço: $e')),
      );
    }
  }

  bool get _isServiceDone {
    return DateTime.now().isAfter(_endDate);
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
                    validator: (value) {
                      if (value == null || int.tryParse(value) == null) {
                        return 'Quantidade de crianças inválida';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  _buildEditableField(
                    icon: Icons.location_on,
                    label: 'Endereço',
                    controller: _addressController,
                    isEditing: _isEditing,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Endereço inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  _buildEditableField(
                    icon: Icons.monetization_on,
                    label: 'Valor',
                    controller: _valueController,
                    isEditing: _isEditing,
                    validator: (value) {
                      if (value == null || double.tryParse(value) == null) {
                        return 'Valor inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8.0),
                  _buildDateField(
                    icon: Icons.calendar_today,
                    label: 'Data de Início',
                    date: _startDate,
                    isEditing: _isEditing,
                    onTap: () => _selectDateTime(context, true),
                  ),
                  const SizedBox(height: 8.0),
                  _buildDateField(
                    icon: Icons.calendar_today_outlined,
                    label: 'Data de Fim',
                    date: _endDate,
                    isEditing: _isEditing,
                    onTap: () => _selectDateTime(context, false),
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
    required FormFieldValidator<String> validator,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.pinkAccent),
        const SizedBox(width: 8.0),
        Expanded(
          child: isEditing
              ? TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: label,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: validator,
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

  Widget _buildDateField({
    required IconData icon,
    required String label,
    required DateTime date,
    required bool isEditing,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.pinkAccent),
        const SizedBox(width: 8.0),
        Expanded(
          child: GestureDetector(
            onTap: isEditing ? onTap : null,
            child: isEditing
                ? AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: label,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      controller: TextEditingController(
                          text: _dateTimeFormat.format(date)),
                      readOnly: !isEditing,
                    ),
                  )
                : Text(
                    '$label: ${_dateTimeFormat.format(date)}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black54,
                    ),
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
            if (widget.babysitterId == null)
              TextButton(
                onPressed: _selectBabysitter, // Ação de selecionar babá
                style: TextButton.styleFrom(
                  side: const BorderSide(color: Colors.pinkAccent), // Contorno rosa
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Bordas arredondadas (opcional)
                  ),
                ),
                child: const Text(
                  'Escolher Babá',
                  style: TextStyle(
                    color: Colors.pinkAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else
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
    _addressController.dispose();
    _valueController.dispose();
    super.dispose();
  }
}
