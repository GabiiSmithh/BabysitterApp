import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:client/common/api_service.dart';
import 'package:client/common/app_bar.dart';
import 'package:client/profile/tutor_profile_service.dart';

class TutorProfileScreen extends StatefulWidget {
  const TutorProfileScreen({super.key});

  @override
  _TutorProfileScreenState createState() => _TutorProfileScreenState();
}

class _TutorProfileScreenState extends State<TutorProfileScreen> {
  String userName = '';
  String userGender = '';
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
        userGender = data['gender'];
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
        // Senha alterada com sucesso
        setState(() {
          isChangingPassword = false;
          isEditing = false;
        });
        // Limpar campos de senha
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmNewPasswordController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Senha alterada com sucesso')),
        );

        _toggleEditing(); // Exit editing mode
      } else {
        // Manipular erro na resposta
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
    final Map<String, dynamic> profileData = {
      'name': userName,
      'email': userEmail,
      'address': addressController.text,
      'cellphone': phoneController.text.replaceAll(RegExp(r'[^\d]'), ''),
      'children_count': int.parse(childrenController.text),
    };

    final response = await http.patch(
      Uri.parse('http://201.23.18.202:3333/tutors/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(profileData),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perfil atualizado com sucesso')),
      );
      _toggleEditing(); // Exit editing mode
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erro ao atualizar perfil: ${response.statusCode}')),
      );
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
                  if (!isEditing) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person,
                              color: const Color.fromARGB(255, 182, 46, 92),
                              size: 28),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Text(
                              'Gênero: $userGender',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black54),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  // Conditionally display profile fields or password change fields
                  if (isChangingPassword) ...[
                    _buildPasswordChangeFields(),
                  ] else ...[
                    _buildProfileField(Icons.email, 'Email', userEmail,
                        editable: isEditing),
                    _buildProfileField(
                        Icons.phone, 'Telefone', phoneController.text,
                        editable: isEditing),
                    _buildProfileField(
                        Icons.home, 'Endereço', addressController.text,
                        editable: isEditing),
                    _buildProfileField(Icons.child_care,
                        'Quantidade de Crianças', childrenController.text,
                        editable: isEditing),
                  ],
                  const SizedBox(height: 20.0),
                  if (!isTutor || !isBabysitter) ...[
                    ElevatedButton(
                      onPressed: _becomeBabysitter,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 182, 46, 92),
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
                      ElevatedButton(
                        onPressed: isEditing ? _saveProfile : _toggleEditing,
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
                      if (isEditing) ...[
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
                            isChangingPassword ? 'Cancelar' : 'Trocar Senha',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileField(IconData icon, String label, String value,
      {bool editable = false}) {
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
                    decoration: InputDecoration(
                      labelText: label,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) {
                      switch (label) {
                        case 'Email':
                          userEmail = text;
                          break;
                        case 'Telefone':
                          phoneController.text = text;
                          break;
                        case 'Endereço':
                          userAddress = text;
                          break;
                        case 'Quantidade de Crianças':
                          userChildrenQuantity = int.parse(text);
                          break;
                      }
                    },
                  )
                : Text(
                    value,
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                    textAlign: TextAlign.start,
                  ),
          ),
        ],
      ),
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

Widget _buildPasswordField(String label, TextEditingController controller, bool isPasswordVisible, Function() togglePasswordVisibility) {
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
