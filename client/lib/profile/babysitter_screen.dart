import 'package:client/common/api_service.dart';
import 'package:client/common/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:client/profile/babysitter_profile_service.dart';
import 'package:intl/intl.dart';

class BabysitterProfileScreen extends StatefulWidget {
  const BabysitterProfileScreen({super.key});

  @override
  _BabysitterProfileScreenState createState() =>
      _BabysitterProfileScreenState();
}

class _BabysitterProfileScreenState extends State<BabysitterProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String userEmail = '';
  String userCellphone = '';
  String userBirthDate = '';
  int userExperienceMonths = 0;
  bool isLoading = true;
  bool isEditing = false;
  String userId = '';
  bool isBabysitter = false;
  bool isTutor = false;
  bool obscureCurrentPassword = true;
  bool obscureNewPassword = true;
  bool obscureConfirmNewPassword = true;

  final phoneController = MaskedTextController(mask: '(00)00000-0000');
  final birthDateController = TextEditingController();
  final experienceMonthsController = TextEditingController();

  bool isChangingPassword = false;
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  @override
  void dispose() {
    phoneController.dispose();
    birthDateController.dispose();
    experienceMonthsController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
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
        Uri.parse('http://201.23.18.202:3333/babysitters/$userId'),
        headers: {'Authorization': 'Bearer $jwtToken'},
      );

      if (profileResponse.statusCode == 200) {
        final data = json.decode(profileResponse.body);
        setState(() {
          userName = data['name'];
          userEmail = data['email'];
          phoneController.text = data['cellphone'];
          userBirthDate = data['birthDate'];
          userExperienceMonths = data['experienceMonths'] ?? 0;
          final parsedDate = DateTime.parse(userBirthDate);
          final formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
          birthDateController.text = formattedDate;
          experienceMonthsController.text = userExperienceMonths.toString();
        });
      } else {
        throw Exception('Falha ao carregar os dados do perfil');
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
      isChangingPassword = false;
    });
  }

  Future<void> _saveProfile() async {
    if (isChangingPassword) {
      // Manipular a troca de senha
      await _changePassword();
    } else {
      if (_formKey.currentState!.validate()) {}

      try {
        final input = {
          'email': userEmail,
          'cellphone': phoneController.text,
          'experienceMonths':
              int.tryParse(experienceMonthsController.text) ?? 0,
        };

        await BabysitterProfileService.updateBabysitterProfile(userId, input);
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

  void _becomeTutor() {
    Navigator.of(context).pushNamed('/become-tutor');
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
                      if (!isChangingPassword)
                        Column(
                          children: [
                            const SizedBox(height: 10.0),
                            _buildProfileField(Icons.calendar_today,
                                'Data de Nascimento', birthDateController.text,
                                controller: birthDateController,
                                validator: (value) {
                              if (value!.isEmpty) {
                                return 'A data de nascimento é obrigatória';
                              }
                              return null;
                            }, editable: false),
                            _buildProfileField(
                                Icons.calendar_month,
                                'Meses de Experiência',
                                experienceMonthsController.text,
                                controller: experienceMonthsController,
                                validator: (value) {
                              if (value!.isEmpty ||
                                  int.tryParse(value) == null) {
                                return 'Informe um número válido de meses';
                              }
                              return null;
                            }, editable: isEditing),
                            _buildProfileField(Icons.email, 'Email', userEmail,
                                initialValue: userEmail, validator: (value) {
                              if (value!.isEmpty ||
                                  !RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                      .hasMatch(value)) {
                                return 'Informe um email válido';
                              }
                              return null;
                            }, editable: isEditing),
                            _buildProfileField(
                                Icons.phone, 'Telefone', phoneController.text,
                                controller: phoneController,
                                validator: (value) {
                              if (value!.isEmpty ||
                                  !RegExp(r'^\(\d{2}\)\d{5}-\d{4}$')
                                      .hasMatch(value)) {
                                return 'Informe um número de telefone válido';
                              }
                              return null;
                            }, editable: isEditing),
                            const SizedBox(height: 20.0),
                          ],
                        ),
                      if (isChangingPassword)
                        Column(
                          children: [
                            _buildPasswordField(
                                'Senha Atual', currentPasswordController,
                                obscureText: obscureCurrentPassword,
                                onToggle: () {
                              setState(() {
                                obscureCurrentPassword =
                                    !obscureCurrentPassword;
                              });
                            }),
                            _buildPasswordField(
                                'Nova Senha', newPasswordController,
                                obscureText: obscureNewPassword, onToggle: () {
                              setState(() {
                                obscureNewPassword = !obscureNewPassword;
                              });
                            }),
                            _buildPasswordField('Confirmar Nova Senha',
                                confirmNewPasswordController,
                                obscureText: obscureConfirmNewPassword,
                                onToggle: () {
                              setState(() {
                                obscureConfirmNewPassword =
                                    !obscureConfirmNewPassword;
                              });
                            }),
                          ],
                        ),
                      const SizedBox(height: 20.0),
                      if (!isChangingPassword)
                        if (isEditing)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: _saveProfile,
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
                                  'Salvar',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                  width: 16.0), // Espaçamento entre os botões
                            ],
                          )
                        else
                          ElevatedButton(
                            onPressed: _toggleEditing,
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
                              'Editar Perfil',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                      const SizedBox(height: 20.0),
                      if (!isEditing)
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isChangingPassword = !isChangingPassword;
                            });
                          },
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
                      if (isChangingPassword) const SizedBox(height: 20.0),
                      if (isChangingPassword)
                        ElevatedButton(
                          onPressed: () async {
                            await _changePassword();
                          },
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
                      const SizedBox(height: 20.0),
                      if (!(isBabysitter && isTutor))
                        ElevatedButton(
                          onPressed: _becomeTutor,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 0, 123, 255),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 30.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Text('Virar Tutor',
                              style: TextStyle(color: Colors.white)),
                        ),
                    ],
                  ),
                ),
              ));
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
      ),
      enabled: editable,
      validator: validator,
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller,
      {required bool obscureText, required VoidCallback onToggle}) {
    IconData prefixIcon;
    switch (label) {
      case 'Senha Atual':
        prefixIcon = Icons.lock_outline;
        break;
      case 'Nova Senha':
        prefixIcon = Icons.lock;
        break;
      case 'Confirmar Nova Senha':
        prefixIcon = Icons.lock;
        break;
      default:
        prefixIcon = Icons.lock;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon:
              Icon(prefixIcon, color: const Color.fromARGB(255, 182, 46, 92)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: const Color.fromARGB(255, 182, 46, 92),
            ),
            onPressed: onToggle,
          ),
        ),
        style: const TextStyle(fontSize: 18, color: Colors.black54),
      ),
    );
  }
}
