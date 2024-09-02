import 'package:client/common/api_service.dart';
import 'package:client/common/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BecomeBabysitterScreen extends StatefulWidget {
  const BecomeBabysitterScreen({super.key});

  @override
  _BecomeBabysitterScreenState createState() => _BecomeBabysitterScreenState();
}

class _BecomeBabysitterScreenState extends State<BecomeBabysitterScreen> {
  final TextEditingController _experienceMonthsController =
      TextEditingController();
  bool isLoading = false;

  Future<void> _becomeBabysitter() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final jwtToken = prefs.getString('jwt_token') ?? '';

      final response = await http.post(
        Uri.parse('http://201.23.18.202:3333/users/roles/babysitter'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: json.encode({
          'experience_months':
              int.tryParse(_experienceMonthsController.text) ?? 0,
        }),
      );

      if (response.statusCode == 201) {
        ApiService.setAuthorizationTokenAndRoles(
            jwtToken, ['tutor', 'babysitter']);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil de babá criado com sucesso')),
        );

        Navigator.of(context).pushNamed('/tutor-profile');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Erro ao criar perfil de babá: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Tornar-se Babá',
        onBackButtonPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: _experienceMonthsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Meses de Experiência',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: isLoading ? null : _becomeBabysitter,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 182, 46, 92),
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 30.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Tornar-se Babá',
                      style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
