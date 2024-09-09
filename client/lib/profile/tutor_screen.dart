import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:client/common/api_service.dart';
import 'package:client/common/app_bar.dart';
import 'package:client/profile/tutor_profile_service.dart';
import 'package:intl/intl.dart'; // Import the intl p

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
  bool isChangingPassword = false;
  bool isTutor = false;
  bool isBabysitter = false;
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmNewPasswordVisible = false;
  String userId = '';

  final phoneController = MaskedTextController(mask: '(00)00000-0000');
  final addressController = TextEditingController();
  final childrenController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();
  final birthDateController = TextEditingController();

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

        final parsedDate = DateTime.parse(userBirthDate);
        final formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
        birthDateController.text = formattedDate;
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
      if (isEditing) {
        isChangingPassword =
            false; // Reset password change mode when starting editing
      }
    });
  }

  void _toggleChangePassword() {
    setState(() {
      isChangingPassword = !isChangingPassword;
    });
  }

  Future<void> _saveProfile() async {
    try {
      if (isChangingPassword) {
        await _changePassword();
      } else {
        await _updateTutorProfile(userId);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.toString()}')),
      );
    }
  }

  Future<void> _changePassword() async {
    final currentPassword = currentPasswordController.text;
    final newPassword = newPasswordController.text;
    final confirmNewPassword = confirmNewPasswordController.text;

    if (newPassword != confirmNewPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As novas senhas não coincidem')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://201.23.18.202:3333/auth/change-password'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': userEmail,
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 204) {
        setState(() {
          isChangingPassword = false;
          isEditing = false;
        });
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmNewPasswordController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Senha alterada com sucesso')),
        );

        _toggleEditing();
      } else {
        final data = json.decode(response.body);
        final errorMessage = data['message'] ?? 'Erro ao alterar a senha';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.toString()}')),
      );
    }
  }

  Future<void> _updateTutorProfile(String userId) async {
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
                      const SizedBox(height: 20.0),
                      if (isChangingPassword) ...[
                        _buildPasswordChangeFields(),
                      ] else ...[
                        _buildProfileField(Icons.calendar_today,
                            'Data de Nascimento', birthDateController.text,
                            controller: birthDateController,
                            validator: (value) {
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
                              !RegExp(r'^\(\d{2}\)\d{5}-\d{4}$')
                                  .hasMatch(value)) {
                            return 'Informe um número de telefone válido';
                          }
                          return null;
                        }, editable: isEditing),
                      ],
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!isChangingPassword)
                            ElevatedButton(
                              onPressed:
                                  isEditing ? _saveProfile : _toggleEditing,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 182, 46, 92),
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
                          const SizedBox(width: 10.0),
                          if (!isEditing)
                            ElevatedButton(
                              onPressed: _toggleChangePassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 182, 46, 92),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 30.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: Text(
                                isChangingPassword
                                    ? 'Cancelar'
                                    : 'Trocar Senha',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          if (isChangingPassword) ...[
                            const SizedBox(width: 10.0),
                            ElevatedButton(
                              onPressed: _changePassword,
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
                                'Confirmar',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ]
                        ],
                      ),
                    ],
                  ))),
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

  Widget _buildPasswordChangeFields() {
    return Column(
      children: [
        _buildPasswordField(
            'Senha Atual', currentPasswordController, _isCurrentPasswordVisible,
            () {
          setState(() {
            _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
          });
        }),
        _buildPasswordField(
            'Nova Senha', newPasswordController, _isNewPasswordVisible, () {
          setState(() {
            _isNewPasswordVisible = !_isNewPasswordVisible;
          });
        }),
        _buildPasswordField('Confirmar Nova Senha',
            confirmNewPasswordController, _isConfirmNewPasswordVisible, () {
          setState(() {
            _isConfirmNewPasswordVisible = !_isConfirmNewPasswordVisible;
          });
        }),
        const SizedBox(height: 20.0),
      ],
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller,
      bool isPasswordVisible, Function() togglePasswordVisibility) {
    IconData icon = label == 'Senha Atual' ? Icons.lock_outline : Icons.lock;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color.fromARGB(255, 182, 46, 92), size: 28),
          const SizedBox(width: 16.0),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: const Color.fromARGB(255, 182, 46, 92),
                  ),
                  onPressed: togglePasswordVisibility,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
