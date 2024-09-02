import 'package:client/common/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'service.dart';

class CreateServicePage extends StatefulWidget {
  const CreateServicePage({super.key});

  @override
  _CreateServicePageState createState() => _CreateServicePageState();
}

class _CreateServicePageState extends State<CreateServicePage> {
  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> formData = {
    'tutor_id': '',
    'start_date': '',
    'end_date': '',
    'value': 0,
    'children_count': 0,
    'address': ''
  };

  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  final Color _cursorColor = const Color.fromARGB(255, 182, 46, 92);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 215, 229),
      appBar: CustomAppBar(
        title: 'Criar novo serviço',
        onBackButtonPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: _buildFormFields(), // Dynamically build form fields
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    return formData.keys.map((key) {
      if (key == 'start_date') {
        return _buildDateField(
          label: 'Data e Hora de Início',
          icon: Icons.calendar_today,
          controller: startDateController,
          onTap: () async {
            DateTime? pickedDate = await _selectDateTime(context);
            if (pickedDate != null) {
              setState(() {
                formData[key] = DateFormat('yyyy-MM-dd').format(pickedDate);
                startDateController.text = formData[key];
              });
            }
          },
          validator: (value) {
            return value!.isEmpty
                ? 'Por favor, selecione a data e hora de início'
                : null;
          },
        );
      } else if (key == 'end_date') {
        return _buildDateField(
          label: 'Data e Hora de Término',
          icon: Icons.calendar_today,
          controller: endDateController,
          onTap: () async {
            DateTime? pickedDate = await _selectDateTime(context);
            if (pickedDate != null) {
              setState(() {
                formData[key] = DateFormat('yyyy-MM-dd').format(pickedDate);
                endDateController.text = formData[key];
              });
            }
          },
          validator: (value) {
            return value!.isEmpty
                ? 'Por favor, selecione a data e hora de término'
                : null;
          },
        );
      } else if (key == 'value') {
        return _buildNumberField(
          label: 'Valor',
          icon: Icons.attach_money,
          initialValue: formData[key].toString(),
          onChanged: (value) {
            setState(() {
              formData[key] = int.tryParse(value ?? '0') ?? 0;
            });
          },
          validator: (value) {
            return value!.isEmpty ? 'Por favor, digite o valor' : null;
          },
        );
      } else if (key == 'children_count') {
        return _buildNumberField(
          label: 'Quantidade de Crianças',
          icon: Icons.child_care,
          initialValue: formData[key].toString(),
          onChanged: (value) {
            setState(() {
              formData[key] = int.tryParse(value ?? '0') ?? 0;
            });
          },
          validator: (value) {
            return value!.isEmpty
                ? 'Por favor, digite a quantidade de crianças'
                : null;
          },
        );
      } else if (key == 'address') {
        return _buildTextField(
          label: 'Endereço',
          icon: Icons.location_on,
          onChanged: (value) {
            setState(() {
              formData[key] = value ?? '';
            });
          },
          validator: (value) {
            return value!.isEmpty ? 'Por favor, digite o endereço' : null;
          },
        );
      } else {
        return const SizedBox.shrink(); // Skip unknown keys
      }
    }).toList()
      ..add(const SizedBox(height: 20.0))
      ..add(
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _createService();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _cursorColor,
            elevation: 5,
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          child: const Text(
            'Criar Serviço',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
  }

  void _createService() async {
    try {
      await BabySittingService.createService(formData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Serviço Criado com Sucesso!')),
      );
      Navigator.of(context).pushNamed('/my-services');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao criar serviço: $e')),
      );
    }
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
