import 'package:client/common/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TutorEditScreen extends StatefulWidget {
  const TutorEditScreen({super.key});

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<TutorEditScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final MaskedTextController _cellphoneController =
      MaskedTextController(mask: '(00) 00000-0000');
  final TextEditingController _childrenCountController =
      TextEditingController();
  final TextEditingController _experienceMonthsController =
      TextEditingController();

  bool _isBabysitterFormVisible = false;
  bool _hasBothRoles = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkRoles();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId != null) {
      final response =
          await http.get(Uri.parse('http://201.23.18.202:3333/tutors/$userId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          _nameController.text = data['name'];
          _emailController.text = data['email'];
          _addressController.text = data['address'];
          _cellphoneController.text = data['cellphone'];
          _childrenCountController.text = data['childrenCount'].toString();
        });
      } else {
        print('Erro ao carregar dados do tutor: ${response.statusCode}');
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
    _addressController.dispose();
    _cellphoneController.dispose();
    _childrenCountController.dispose();
    _experienceMonthsController.dispose();
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

      if (_isBabysitterFormVisible) {
        await _postBabysitterRole(jwtToken);
      } else {
        await _updateTutorProfile(userId);
      }
    }
  }

  Future<void> _postBabysitterRole(String jwtToken) async {
    final experienceMonths = int.parse(_experienceMonthsController.text);

    final response = await http.post(
      Uri.parse('http://201.23.18.202:3333/users/roles/babysitter'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      body: json.encode({
        'experience_months': experienceMonths,
      }),
    );

    if (response.statusCode == 201) {
      ApiService.setAuthorizationTokenAndRoles(
          jwtToken, ['babysitter', 'tutor']);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil de Babá criado com sucesso')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Erro ao criar perfil de Babá: ${response.statusCode}')),
      );
    }
  }

  Future<void> _updateTutorProfile(String userId) async {
    final Map<String, dynamic> profileData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'address': _addressController.text,
      'cellphone': _cellphoneController.text.replaceAll(RegExp(r'[^\d]'), ''),
      'children_count': int.parse(_childrenCountController.text),
    };

    final response = await http.patch(
      Uri.parse('http://201.23.18.202:3333/tutors/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(profileData),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erro ao atualizar perfil: ${response.statusCode}')),
      );
    }
  }

  void _becomeBabysitter() {
    setState(() {
      _isBabysitterFormVisible = !_isBabysitterFormVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 182, 46, 92),
        title: const Text(
          'Editar Perfil Tutor',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_isBabysitterFormVisible) ...[
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
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Por favor, insira um email válido';
                    }
                    return null;
                  },
                ),
                _buildProfileField(
                  controller: _addressController,
                  label: 'Endereço',
                  icon: Icons.home,
                ),
                _buildProfileField(
                  controller: _cellphoneController,
                  label: 'Telefone',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    final cleanedValue =
                        value?.replaceAll(RegExp(r'[^\d]'), '');
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu número de telefone';
                    }
                    if (cleanedValue?.length != 11) {
                      return 'Por favor, insira um número de telefone válido';
                    }
                    return null;
                  },
                ),
                _buildProfileField(
                  controller: _childrenCountController,
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
              if (_isBabysitterFormVisible) ...[
                _buildProfileField(
                  controller: _experienceMonthsController,
                  label: 'Experiência (em meses)',
                  icon: Icons.timer,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua experiência em meses';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Por favor, insira um número válido';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 30.0),
              Row(
                children: [
                  const Spacer(),
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
                  const Spacer(),
                  if (!_hasBothRoles) ...[
                    ElevatedButton(
                      onPressed: _becomeBabysitter,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 182, 46, 92),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14.0, horizontal: 40.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text(
                        _isBabysitterFormVisible ? 'Cancelar' : 'Virar Babá',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                ],
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
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
