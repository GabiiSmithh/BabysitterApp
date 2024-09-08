import 'package:client/common/api_service.dart';
import 'package:client/common/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BecomeTutorScreen extends StatefulWidget {
  const BecomeTutorScreen({super.key});

  @override
  _BecomeTutorScreenState createState() => _BecomeTutorScreenState();
}

class _BecomeTutorScreenState extends State<BecomeTutorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _childrenQuantityController =
      TextEditingController();
  bool isLoading = false;

  Future<void> _becomeTutor() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final prefs = await SharedPreferences.getInstance();
        final jwtToken = prefs.getString('jwt_token') ?? '';

        final response = await http.post(
          Uri.parse('http://201.23.18.202:3333/users/roles/tutor'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwtToken',
          },
          body: json.encode({
            'address': _addressController.text,
            'children_count': int.tryParse(_childrenQuantityController.text) ?? 0,
          }),
        );

        if (response.statusCode == 201) {
          ApiService.setAuthorizationTokenAndRoles(
              jwtToken, ['babysitter', 'tutor']);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil de tutor criado com sucesso')),
          );

          Navigator.of(context).pushNamed('/babysitter-profile');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Erro ao criar perfil de tutor: ${response.statusCode}'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Tornar-se Tutor',
        onBackButtonPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Endereço',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O endereço é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _childrenQuantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantidade de Crianças',
                  border: OutlineInputBorder(),
                ),
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
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: isLoading ? null : _becomeTutor,
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
                    : const Text('Tornar-se Tutor',
                        style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
