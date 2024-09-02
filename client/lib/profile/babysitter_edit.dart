import 'package:client/common/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BabysitterEditScreen extends StatefulWidget {
  const BabysitterEditScreen({super.key});

  @override
  _BabysitterEditScreenState createState() => _BabysitterEditScreenState();
}

class _BabysitterEditScreenState extends State<BabysitterEditScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isTutor = false;
  bool _hasBothRoles = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cellphoneController =
      MaskedTextController(mask: '(00)00000-0000');
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _childrenQuantityController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkRoles(); // Verifica os papéis ao iniciar
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId != null) {
      final response = await http
          .get(Uri.parse('http://201.23.18.202:3333/babysitters/$userId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          _nameController.text = data['name'];
          _emailController.text = data['email'];
          _cellphoneController.text = data['cellphone'];
          _experienceController.text = data['experienceMonths'].toString();
          _addressController.text = data['address'] ?? '';
          _childrenQuantityController.text =
              data['childrenQuantity']?.toString() ?? '';
        });
      } else {
        print('Erro ao carregar dados do babysitter: ${response.statusCode}');
      }
    } else {
      print('user_id não encontrado');
    }
  }

  Future<void> _checkRoles() async {
    try {
      final roles = await ApiService.getRoles();
      setState(() {
        _hasBothRoles = roles.contains('babysitter') && roles.contains('tutor');
      });
    } catch (e) {
      print('Error fetching roles: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cellphoneController.dispose();
    _experienceController.dispose();
    _addressController.dispose();
    _childrenQuantityController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      final jwtToken = prefs.getString('jwt_token');

      if (userId == null || jwtToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro: user_id ou jwt_token não encontrado')),
        );
        return;
      }

      final Map<String, dynamic> profileData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'cellphone': _cellphoneController.text.replaceAll(RegExp(r'[^\d]'), ''),
        'experience_months': int.parse(_experienceController.text),
        if (_isTutor) ...{
          'address': _addressController.text,
          'children_count': int.tryParse(_childrenQuantityController.text) ?? 0,
        }
      };

      if (_isTutor) {
        final response = await http.post(
          Uri.parse('http://201.23.18.202:3333/users/roles/tutor'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwtToken',
          },
          body: json.encode({
            'address': _addressController.text,
            'children_count':
                int.tryParse(_childrenQuantityController.text) ?? 0,
          }),
        );

        if (response.statusCode == 201) {
          ApiService.setAuthorizationTokenAndRoles(
              jwtToken, ['babysitter', 'tutor']);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil de tutor criado com sucesso')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Erro ao criar perfil de tutor: ${response.statusCode}')),
          );
        }
      } else {
        final response = await http.patch(
          Uri.parse('http://201.23.18.202:3333/babysitters/$userId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwtToken',
          },
          body: json.encode(profileData),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil atualizado com sucesso')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Erro ao atualizar perfil: ${response.statusCode}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 182, 46, 92),
        title: const Text(
          'Editar Perfil Babá',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
              if (!_isTutor) ...[
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
                    if (value != null &&
                        value.isNotEmpty &&
                        !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
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
                    final cleanedValue =
                        value?.replaceAll(RegExp(r'[^\d]'), '');
                    if (value != null &&
                        value.isNotEmpty &&
                        cleanedValue?.length != 11) {
                      return 'Número de telefone inválido';
                    }
                    return null;
                  },
                ),
                _buildProfileField(
                  controller: _experienceController,
                  label: 'Experiência (em meses)',
                  icon: Icons.timer,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        int.tryParse(value) == null) {
                      return 'Digite um número válido';
                    }
                    return null;
                  },
                ),
              ] else ...[
                _buildProfileField(
                  controller: _addressController,
                  label: 'Endereço',
                  icon: Icons.home,
                ),
                _buildProfileField(
                  controller: _childrenQuantityController,
                  label: 'Quantidade de Crianças',
                  icon: Icons.child_care,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a quantidade de crianças';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Por favor, insira um número válido';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 30.0),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 182, 46, 92),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14.0, horizontal: 40.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        'Salvar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    if (!_hasBothRoles) ...[
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isTutor = !_isTutor;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 182, 46, 92),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 40.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text(
                          _isTutor ? 'Voltar' : 'Virar Tutor',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
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
          prefixIcon: Icon(icon, color: const Color.fromARGB(255, 182, 46, 92)),
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
}
