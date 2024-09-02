import 'dart:convert';
import 'package:client/common/api_service.dart';
import 'package:client/common/auth_service.dart';
import 'package:client/tutor/service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorSignUpPage extends StatefulWidget {
  const TutorSignUpPage({super.key});

  @override
  _TutorSignUpPageState createState() => _TutorSignUpPageState();
}

class _TutorSignUpPageState extends State<TutorSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String gender = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String phoneNumber = '';
  DateTime birthDate = DateTime.now();
  String address = '';
  int numberOfChildren = 0;

  final Color _cursorColor =
      const Color.fromARGB(255, 182, 46, 92); // Cor magenta
  final Color _topContainerColor =
      const Color.fromARGB(255, 182, 46, 92); // Cor sólida

  final phoneController = MaskedTextController(mask: '(00)00000-0000');
  final birthDateController = TextEditingController();

  bool _showPopup = false;

  @override
  void initState() {
    super.initState();
    birthDateController.addListener(() {
      final text = birthDateController.text;
      if (text.length == 2 || text.length == 5) {
        birthDateController.text = '$text/';
        birthDateController.selection = TextSelection.fromPosition(
          TextPosition(offset: birthDateController.text.length),
        );
      }
    });
  }

  Future<void> _registerTutor() async {
    try {
      // Remove todos os caracteres que não são dígitos
      final cleanedPhoneNumber =
          phoneController.text.replaceAll(RegExp(r'[^\d]'), '');

      final payload = {
        'name': name,
        'gender': gender,
        'email': email,
        'password': password,
        'cellphone': cleanedPhoneNumber,
        'birth_date': birthDate.toIso8601String(),
        'address': address,
        'children_count': numberOfChildren
      };
      await TutorRegisterService.createTutor(payload);

      Navigator.of(context).pushNamed('/services');
    } catch (e) {
      _showFailurePopup(e.toString());
    }
  }

  void _showFailurePopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Text('Falha no cadastro: $message'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 215, 229),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 70.0,
                decoration: BoxDecoration(
                  color: _topContainerColor, // Cor sólida
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(
                        50.0), // Extremidade esquerda arredondada
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 16.0,
                      top: 12.0,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.white, size: 30.0),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const Center(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Cadastre-se como Tutor',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        _buildTextField(
                          label: 'Nome',
                          icon: Icons.person,
                          onChanged: (value) {
                            setState(() {
                              name = value!;
                            });
                          },
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Por favor, digite seu nome'
                                : null;
                          },
                        ),
                        _buildDropdownField(
                          label: 'Gênero',
                          items: ['Homem', 'Mulher', 'Outro'],
                          onChanged: (value) {
                            setState(() {
                              gender = value!;
                            });
                          },
                          validator: (value) {
                            return value == null
                                ? 'Por favor, selecione seu gênero'
                                : null;
                          },
                        ),
                        _buildTextField(
                          label: 'Email',
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            setState(() {
                              email = value!;
                            });
                          },
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Por favor, digite seu email'
                                : null;
                          },
                        ),
                        _buildTextField(
                          label: 'Senha',
                          icon: Icons.lock,
                          obscureText: true,
                          onChanged: (value) {
                            setState(() {
                              password = value!;
                            });
                          },
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Por favor, digite sua senha'
                                : null;
                          },
                        ),
                        _buildTextField(
                          label: 'Confirmar Senha',
                          icon: Icons.lock,
                          obscureText: true,
                          onChanged: (value) {
                            setState(() {
                              confirmPassword = value!;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, confirme sua senha';
                            }
                            if (value != password) {
                              return 'As senhas não coincidem';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          label: 'Telefone',
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          controller: phoneController,
                          onChanged: (value) {
                            setState(() {
                              phoneNumber = value!;
                            });
                          },
                          validator: (value) {
                            return _validatePhoneNumber(value);
                          },
                        ),
                        _buildTextField(
                          label: 'Logradouro',
                          icon: Icons.home,
                          onChanged: (value) {
                            setState(() {
                              address = value!;
                            });
                          },
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Por favor, digite um endereço'
                                : null;
                          },
                        ),
                        _buildNumberField(
                          label: 'Número de Filhos',
                          icon: Icons.child_care,
                          initialValue: numberOfChildren.toString(),
                          onChanged: (value) {
                            setState(() {
                              numberOfChildren = int.tryParse(value ?? '') ?? 0;
                              print(value);
                              print(numberOfChildren);
                            });
                          },
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Por favor, digite a quantidade de crianças'
                                : null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // Save the form data
                              _formKey.currentState!.save();
                              // Process the sign-up data here
                              await _registerTutor();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _cursorColor,
                            elevation: 5,
                            padding: const EdgeInsets.symmetric(
                                vertical: 14.0, horizontal: 24.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Text(
                            'Cadastrar-se',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_showPopup) // Exibe o container apenas se _showPopup for true
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          255, 255, 215, 229), // Cor de fundo do container
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Cadastro realizado com sucesso!',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showPopup = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _cursorColor,
                            elevation: 5,
                            padding: const EdgeInsets.symmetric(
                                vertical: 14.0, horizontal: 24.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Text(
                            'OK',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  DateTime? _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
    } catch (e) {
      // Handle parse error
    }
    return null;
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite uma data válida';
    }
    final date = _parseDate(value);
    if (date == null || date.isAfter(DateTime.now())) {
      return 'Data inválida';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    final cleanedValue = value?.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanedValue?.length != 11) {
      return 'Número de telefone inválido. Deve ter 11 dígitos.';
    }
    if (value == null || value.isEmpty) {
      return 'Por favor, digite seu telefone';
    }
    return null;
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextEditingController? controller,
    required FormFieldSetter<String> onChanged,
    required FormFieldValidator<String> validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        cursorColor: _cursorColor,
        inputFormatters: inputFormatters,
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required List<String> items,
    required FormFieldSetter<String?> onChanged,
    required FormFieldValidator<String?> validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButtonFormField<String>(
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required String label,
    required IconData icon,
    required String initialValue,
    required FormFieldSetter<String> onChanged,
    required FormFieldValidator<String> validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        cursorColor: _cursorColor,
      ),
    );
  }
}
