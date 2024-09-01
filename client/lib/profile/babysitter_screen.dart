import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:client/common/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = '';
  String userGender = '';
  String userEmail = '';
  String userCellphone = '';
  String userBirthDate = '';
  int userExperienceMonths = 0;
  int userAge = 0;
  String userAddress = '';
  int userChildrenQuantity = 0;
  bool isLoading = true;
  bool isTutor = false;
  String userId = '';

  final phoneController = MaskedTextController(mask: '(00)00000-0000');

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
      _checkProfileType();
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ID não encontrado')),
      );
    }
  }

  Future<void> _checkProfileType() async {
    final profileType = AuthService.getCurrentProfileType();
    setState(() {
      isTutor = profileType == 'tutor';
    });
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    final url = isTutor ? 'tutors' : 'babysitters';
    try {
      final response = await http.get(
        Uri.parse('http://201.23.18.202:3333/$url/$userId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userName = data['name'];
          userGender = data['gender'];
          userEmail = data['email'];
          phoneController.text = data['cellphone'];
          userBirthDate = data['birthDate'];
          userExperienceMonths = data['experienceMonths'] ?? 0;
          userAddress = data['address'] ?? '';
          userChildrenQuantity = data['childrenCount'] ?? 0;
          userAge = _calculateAge(DateTime.parse(userBirthDate));
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load profile data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.toString()}')),
      );
    }
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 215, 229),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 182, 46, 92),
        title: Text(
          'Perfil ${isTutor ? "do Tutor" : "da Babá"}',
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Color.fromARGB(255, 182, 46, 92),
                    child: Text(
                      userName.isNotEmpty ? userName[0] : '',
                      style: TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 30,
                      color: Color.fromARGB(255, 182, 46, 92),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
                  _buildProfileField(Icons.calendar_today, 'Idade', '$userAge anos'),
                  SizedBox(height: 20.0),
                  _buildProfileField(Icons.person, 'Gênero', userGender),
                  _buildProfileField(Icons.email, 'Email', userEmail),
                  _buildProfileField(Icons.phone, 'Telefone', phoneController.text),
                  if (!isTutor) ...[
                    _buildProfileField(Icons.work, 'Experiência', '$userExperienceMonths meses'),
                  ],
                  if (isTutor) ...[
                    _buildProfileField(Icons.home, 'Endereço', userAddress),
                    _buildProfileField(Icons.child_care, 'Quantidade de Crianças', '$userChildrenQuantity'),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildProfileField(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Color.fromARGB(255, 182, 46, 92), size: 28),
          SizedBox(width: 16.0),
          Text(
            '$label: $value',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
