import 'package:client/common/api_service.dart';
import 'package:client/common/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BabysitterProfileScreen extends StatefulWidget {
  const BabysitterProfileScreen({super.key});

  @override
  _BabysitterProfileScreenState createState() =>
      _BabysitterProfileScreenState();
}

class _BabysitterProfileScreenState extends State<BabysitterProfileScreen> {
  String userName = '';
  String userGender = '';
  String userEmail = '';
  String userCellphone = '';
  String userBirthDate = '';
  int userExperienceMonths = 0;
  bool isLoading = true;
  bool isEditing = false;
  String userId = '';
  bool isBabysitter = false;
  bool isTutor = false;

  final phoneController = MaskedTextController(mask: '(00)00000-0000');
  final addressController = TextEditingController();
  final childrenController = TextEditingController();
  final birthDateController = TextEditingController();
  final experienceMonthsController = TextEditingController();

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

      // Fetch user profile data
      final profileResponse = await http.get(
        Uri.parse('http://201.23.18.202:3333/babysitters/$userId'),
        headers: {'Authorization': 'Bearer $jwtToken'},
      );

      if (profileResponse.statusCode == 200) {
        final data = json.decode(profileResponse.body);
        setState(() {
          userName = data['name'];
          userGender = data['gender'];
          userEmail = data['email'];
          phoneController.text = data['cellphone'];
          userBirthDate = data['birthDate'];
          userExperienceMonths = data['experienceMonths'] ?? 0;
          addressController.text = data['address'] ?? '';
          childrenController.text = data['childrenCount']?.toString() ?? '0';
          birthDateController.text = userBirthDate;
          experienceMonthsController.text = userExperienceMonths.toString();
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
    try {
      await http.patch(
        Uri.parse('http://201.23.18.202:3333/babysitters/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': userName,
          'gender': userGender,
          'email': userEmail,
          'cellphone': phoneController.text,
          'address': addressController.text,
          'childrenCount': int.tryParse(childrenController.text) ?? 0,
          'birthDate': birthDateController.text,
          'experienceMonths':
              int.tryParse(experienceMonthsController.text) ?? 0,
        }),
      );
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
                  _buildProfileField(Icons.calendar_today, 'Data de Nascimento',
                      birthDateController.text,
                      editable: isEditing),
                  _buildProfileField(Icons.calendar_month,
                      'Meses de Experiência', experienceMonthsController.text,
                      editable: isEditing),
                  _buildProfileField(Icons.person, 'Gênero', userGender,
                      editable: isEditing),
                  _buildProfileField(Icons.email, 'Email', userEmail,
                      editable: isEditing),
                  _buildProfileField(
                      Icons.phone, 'Telefone', phoneController.text,
                      editable: isEditing),
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
                      onPressed: _becomeTutor,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 123, 255),
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
                    onChanged: (newValue) {
                      switch (label) {
                        case 'Gênero':
                          userGender = newValue;
                          break;
                        case 'Email':
                          userEmail = newValue;
                          break;
                        case 'Telefone':
                          phoneController.text = newValue;
                          break;
                        case 'Data de Nascimento':
                          birthDateController.text = newValue;
                          break;
                        case 'Meses de Experiência':
                          experienceMonthsController.text = newValue;
                          break;
                      }
                    },
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
