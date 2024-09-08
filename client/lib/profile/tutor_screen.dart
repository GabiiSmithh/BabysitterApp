import 'package:client/common/api_service.dart';
import 'package:client/common/app_bar.dart';
import 'package:client/profile/tutor_profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Import the intl package

class TutorProfileScreen extends StatefulWidget {
  const TutorProfileScreen({super.key});

  @override
  _TutorProfileScreenState createState() => _TutorProfileScreenState();
}

class _TutorProfileScreenState extends State<TutorProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String userEmail = '';
  String userCellphone = '';
  String userBirthDate = '';
  String userAddress = '';
  int userChildrenQuantity = 0;
  bool isLoading = true;
  bool isEditing = false;
  String userId = '';
  bool isTutor = false;
  bool isBabysitter = false;

  final phoneController = MaskedTextController(mask: '(00)00000-0000');
  final birthDateController = TextEditingController();
  final addressController = TextEditingController();
  final childrenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id') ?? '';
    });
    if (userId.isNotEmpty) {
      _fetchProfileData();
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID não encontrado')),
      );
    }
  }

  Future<void> _fetchProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jwtToken = prefs.getString('jwt_token') ?? '';

      final profileResponse = await http.get(
        Uri.parse('http://201.23.18.202:3333/tutors/$userId'),
        headers: {'Authorization': 'Bearer $jwtToken'},
      );

      if (profileResponse.statusCode == 200) {
        final data = json.decode(profileResponse.body);
        setState(() {
          userName = data['name'];
          userEmail = data['email'];
          phoneController.text = data['cellphone'];
          userBirthDate = data['birthDate'];
          userAddress = data['address'] ?? '';
          userChildrenQuantity = data['childrenCount'] ?? 0;

          final parsedDate = DateTime.parse(userBirthDate);
          final formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
          birthDateController.text = formattedDate;
          addressController.text = userAddress;
          childrenController.text = userChildrenQuantity.toString();
        });
      } else {
        throw Exception('Failed to load profile data');
      }

      final userRoles = await ApiService.getRoles();

      setState(() {
        isBabysitter = userRoles.contains('babysitter');
        isTutor = userRoles.contains('tutor');
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.toString()}')),
      );
    }
  }

  void _toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final input = {
          'email': userEmail,
          'cellphone': phoneController.text,
          'childrenCount': int.tryParse(childrenController.text) ?? 0,
          'address': addressController.text,
        };

        await TutorProfileService.updateTutorProfile(userId, input);
        _toggleEditing();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil atualizado com sucesso')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${e.toString()}')),
        );
      }
    }
  }

  void _becomeBabysitter() {
    Navigator.of(context).pushNamed('/become-babysitter');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 215, 229),
      appBar: CustomAppBar(
        title: 'Meu Perfil',
        onBackButtonPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: const Color.fromARGB(255, 182, 46, 92),
                      child: Text(
                        userName.isNotEmpty ? userName[0] : '',
                        style: const TextStyle(
                          fontSize: 50,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 30,
                        color: Color.fromARGB(255, 182, 46, 92),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10.0),
                    _buildProfileField(Icons.calendar_today,
                        'Data de Nascimento', birthDateController.text,
                        controller: birthDateController, validator: (value) {
                      if (value!.isEmpty) {
                        return 'A data de nascimento é obrigatória';
                      }
                      return null;
                    }, editable: false),
                    const SizedBox(height: 20.0),
                    _buildProfileField(
                        Icons.home, 'Endereço', addressController.text,
                        controller: addressController, validator: (value) {
                      if (value!.isEmpty) {
                        return 'O endereço é obrigatório';
                      }
                      return null;
                    }, editable: isEditing),
                    const SizedBox(height: 20.0),
                    _buildProfileField(Icons.child_care,
                        'Quantidade de Crianças', childrenController.text,
                        controller: childrenController, validator: (value) {
                      if (value!.isEmpty || int.tryParse(value) == null) {
                        return 'Informe um número válido de crianças';
                      }
                      return null;
                    }, editable: isEditing),
                    const SizedBox(height: 20.0),
                    _buildProfileField(Icons.email, 'Email', userEmail,
                        initialValue: userEmail, validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Informe um email válido';
                      }
                      return null;
                    }, editable: isEditing),
                    const SizedBox(height: 20.0),
                    _buildProfileField(
                        Icons.phone, 'Telefone', phoneController.text,
                        controller: phoneController, validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r'^\(\d{2}\)\d{5}-\d{4}$').hasMatch(value)) {
                        return 'Informe um número de telefone válido';
                      }
                      return null;
                    }, editable: isEditing),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: isEditing ? _saveProfile : _toggleEditing,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 182, 46, 92),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 30.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text(
                        isEditing ? 'Salvar' : 'Editar Perfil',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    if (!(isBabysitter && isTutor))
                      ElevatedButton(
                        onPressed: _becomeBabysitter,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 0, 123, 255),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 30.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Text(
                          'Virar Babá',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileField(
    IconData icon,
    String label,
    String value, {
    TextEditingController? controller,
    bool editable = false,
    String? Function(String?)? validator,
    String? initialValue,
  }) {
    return TextFormField(
      initialValue: initialValue,
      controller: controller,
      decoration: InputDecoration(
        icon: Icon(icon),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      enabled: editable,
      validator: validator,
    );
  }
}
