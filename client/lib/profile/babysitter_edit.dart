import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class BabysitterEditScreen extends StatefulWidget {
  @override
  _BabysitterEditScreenState createState() => _BabysitterEditScreenState();
}

class _BabysitterEditScreenState extends State<BabysitterEditScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cellphoneController = MaskedTextController(mask: '(00)00000-0000');
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  // Original values
  late String _originalName;
  late String _originalEmail;
  late String _originalCellphone;
  late String _originalExperience;
  late String _originalBirthDate;

  @override
  void initState() {
    super.initState();
    // Load original values
    _loadOriginalValues();
    // Initialize controllers with original values
    _nameController.text = _originalName;
    _emailController.text = _originalEmail;
    _cellphoneController.text = _originalCellphone;
    _experienceController.text = _originalExperience;
    _birthDateController.text = _originalBirthDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cellphoneController.dispose();
    _experienceController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  void _loadOriginalValues() {
    // Here you would fetch the original values from your data source
    // For this example, we set them to empty strings. Replace with actual data.
    _originalName = '';
    _originalEmail = '';
    _originalCellphone = '';
    _originalExperience = '';
    _originalBirthDate = '';
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Here, you would usually send the updated data to the server
      // For now, just show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perfil atualizado com sucesso')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 182, 46, 92),
        title: Text(
          'Editar Perfil',
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
              _buildProfileField(
                controller: _nameController,
                label: 'Nome',
                icon: Icons.person,
              ),
              _buildProfileField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != null && value.isNotEmpty && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Digite um e-mail válido';
                  }
                  return null;
                },
              ),
              _buildProfileField(
                controller: _cellphoneController,
                label: 'Telefone',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  final cleanedValue = value?.replaceAll(RegExp(r'[^\d]'), '');
                  if (value != null && value.isNotEmpty && cleanedValue?.length != 11) {
                    return 'Número de telefone inválido';
                  }
                  return null;
                },
              ),
              _buildProfileField(
                controller: _experienceController,
                label: 'Experiência (em anos)',
                icon: Icons.timer,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                    return 'Digite um número válido';
                  }
                  return null;
                },
              ),
              _buildProfileField(
                controller: _birthDateController,
                label: 'Data de Nascimento (DD/MM/AAAA)',
                icon: Icons.calendar_today,
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  final date = _parseDate(value ?? '');
                  if (value != null && value.isNotEmpty && (date == null || date.isAfter(DateTime.now()))) {
                    return 'Data inválida';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30.0),
              Center(
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 182, 46, 92),
                    padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 40.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text(
                    'Salvar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Color.fromARGB(255, 182, 46, 92)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  DateTime? _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
    } catch (e) {
      // Handle parse error
    }
    return null;
  }
}
