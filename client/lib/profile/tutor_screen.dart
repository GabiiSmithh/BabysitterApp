import 'package:client/common/api_service.dart';
import 'package:client/common/app_bar.dart';
import 'package:client/profile/tutor_profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool isTutor = false;
  bool isBabysitter = false;
  String userId = '';

  final phoneController = MaskedTextController(mask: '(00)00000-0000');
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
      final data = await TutorProfileService.fetchData(userId);
      final userRoles = await ApiService.getRoles();
      setState(() {
        userName = data['name'];
        userEmail = data['email'];
        phoneController.text = data['cellphone'];
        userBirthDate = data['birthDate'];
        addressController.text = data['address'] ?? '';
        childrenController.text = data['childrenCount']?.toString() ?? '0';
        userAddress = data['address'] ?? '';
        userChildrenQuantity = data['childrenCount'] ?? 0;
        isLoading = false;
      });

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

  Future<void> _becomeBabysitter() async {
    Navigator.of(context).pushNamed('/become-babysitter');
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
          'childrenCount':
              int.tryParse(childrenController.text) ?? 0,
          'address': addressController.text,
        };

        await TutorProfileService.updateTutorProfile(userId, input);
        _toggleEditing(); // Exit editing mode
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
                    _buildProfileField(
                      Icons.email,
                      'Email',
                      userEmail,
                      editable: isEditing,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'O email é obrigatório';
                        }
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Informe um email válido';
                        }
                        return null;
                      },
                      onChanged: (newValue) {
                        userEmail = newValue;
                      },
                    ),
                    _buildProfileField(
                      Icons.phone,
                      'Telefone',
                      phoneController.text,
                      editable: isEditing,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'O telefone é obrigatório';
                        }
                        if (!RegExp(r'\(\d{2}\)\d{5}-\d{4}').hasMatch(value)) {
                          return 'Informe um telefone válido';
                        }
                        return null;
                      },
                      onChanged: (newValue) {
                        phoneController.text = newValue;
                      },
                    ),
                    _buildProfileField(
                      Icons.home,
                      'Endereço',
                      addressController.text,
                      editable: isEditing,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'O endereço é obrigatório';
                        }
                        return null;
                      },
                      onChanged: (newValue) {
                        addressController.text = newValue;
                      },
                    ),
                    _buildProfileField(
                      Icons.child_care,
                      'Quantidade de Crianças',
                      childrenController.text,
                      editable: isEditing,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'A quantidade de crianças é obrigatória';
                        }
                        final intValue = int.tryParse(value);
                        if (intValue == null || intValue < 0) {
                          return 'Informe um número válido de crianças';
                        }
                        return null;
                      },
                      onChanged: (newValue) {
                        childrenController.text = newValue;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    if (!isTutor || !isBabysitter) ...[
                      ElevatedButton(
                        onPressed: _becomeBabysitter,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 182, 46, 92),
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
                      const SizedBox(height: 20.0),
                    ],
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
    required bool editable,
    String? Function(String?)? validator,
    required void Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color.fromARGB(255, 182, 46, 92), size: 28),
          const SizedBox(width: 16.0),
          Expanded(
            child: editable
                ? TextFormField(
                    initialValue: value,
                    onChanged: onChanged,
                    validator: validator,
                    decoration: InputDecoration(
                      labelText: label,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                  )
                : Text(
                    '$label: $value',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.start,
                  ),
          ),
        ],
      ),
    );
  }
}
