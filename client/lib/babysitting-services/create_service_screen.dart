import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateServicePage extends StatefulWidget {
  @override
  _CreateServicePageState createState() => _CreateServicePageState();
}

class _CreateServicePageState extends State<CreateServicePage> {
  final _formKey = GlobalKey<FormState>();
  String tutorName = '';
  int numberOfChildren = 1;
  DateTime? startDate;
  DateTime? endDate;
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  final Color _cursorColor = Color.fromARGB(255, 182, 46, 92);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 215, 229),
      appBar: AppBar(
        backgroundColor: _cursorColor,
        title: Text(
          'Criar Novo Serviço',
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                label: 'Nome do Tutor',
                icon: Icons.person,
                onChanged: (value) {
                  setState(() {
                    tutorName = value ?? '';
                  });
                },
                validator: (value) {
                  return value!.isEmpty
                      ? 'Por favor, digite o nome do tutor'
                      : null;
                },
              ),
              _buildNumberField(
                label: 'Quantidade de Crianças',
                icon: Icons.child_care,
                initialValue: numberOfChildren.toString(),
                onChanged: (value) {
                  setState(() {
                    numberOfChildren = int.tryParse(value ?? '1') ?? 1;
                  });
                },
                validator: (value) {
                  return value!.isEmpty
                      ? 'Por favor, digite a quantidade de crianças'
                      : null;
                },
              ),
              _buildDateField(
                label: 'Data e Hora de Início',
                icon: Icons.calendar_today,
                controller: startDateController,
                onTap: () async {
                  DateTime? pickedDate = await _selectDateTime(context);
                  if (pickedDate != null) {
                    setState(() {
                      startDate = pickedDate;
                      startDateController.text =
                          DateFormat('dd/MM/yyyy HH:mm').format(startDate!);
                    });
                  }
                },
                validator: (value) {
                  return value!.isEmpty
                      ? 'Por favor, selecione a data e hora de início'
                      : null;
                },
              ),
              _buildDateField(
                label: 'Data e Hora de Término',
                icon: Icons.calendar_today,
                controller: endDateController,
                onTap: () async {
                  DateTime? pickedDate = await _selectDateTime(context);
                  if (pickedDate != null) {
                    setState(() {
                      endDate = pickedDate;
                      endDateController.text =
                          DateFormat('dd/MM/yyyy HH:mm').format(endDate!);
                    });
                  }
                },
                validator: (value) {
                  return value!.isEmpty
                      ? 'Por favor, selecione a data e hora de término'
                      : null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Process the service creation here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Serviço Criado com Sucesso!')),
                    );
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _cursorColor,
                  elevation: 5,
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text(
                  'Criar Serviço',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required FormFieldSetter<String> onChanged,
    required FormFieldValidator<String> validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        cursorColor: _cursorColor,
      ),
    );
  }

  Widget _buildNumberField({
    required String label,
    required IconData icon,
    required String initialValue,
    required FormFieldSetter<String> onChanged,
    required FormFieldValidator<String> validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        cursorColor: _cursorColor,
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required VoidCallback onTap,
    required FormFieldValidator<String> validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        cursorColor: _cursorColor,
      ),
    );
  }

  Future<DateTime?> _selectDateTime(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );

      if (time != null) {
        return DateTime(
            date.year, date.month, date.day, time.hour, time.minute);
      }
    }
    return null;
  }
}
