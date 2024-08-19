import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class BabysitterSignUpPage extends StatefulWidget {
  @override
  _BabysitterSignUpPageState createState() => _BabysitterSignUpPageState();
}

class _BabysitterSignUpPageState extends State<BabysitterSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String gender = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String phoneNumber = '';
  String experienceTime = '';
  DateTime birthDate = DateTime.now();

  final Color _cursorColor = Color.fromARGB(255, 182, 46, 92); // Cor magenta
  final Color _topContainerColor =
      Color.fromARGB(255, 182, 46, 92); // Cor sólida

  final phoneController = MaskedTextController(mask: '(00)00000-0000');
  final birthDateController = TextEditingController();

  bool _showPopup = false; // Variável para controlar a visibilidade do popup

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

  Future<void> _registerBabysitter() async {
    final url = Uri.parse('http://201.23.18.202:3333/babysitters');

    // Remove todos os caracteres que não são dígitos
    final cleanedPhoneNumber =
        phoneController.text.replaceAll(RegExp(r'[^\d]'), '');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': name,
        'gender': gender,
        'email': email,
        'password': password,
        'cellphone': cleanedPhoneNumber,
        'birth_date': "${birthDate.toIso8601String()}",
        'experience_months': int.tryParse(experienceTime) ?? 0,
      }),
    );

    if (response.statusCode == 201) {
      // Cadastro realizado com sucesso
      _showSuccessPopup();
    } else {
      // Falha no cadastro
      _showFailurePopup(response.body);
    }
  }

  void _showSuccessPopup() {
    setState(() {
      _showPopup = true;
    });
  }

  void _showFailurePopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro'),
          content: Text('Falha no cadastro: $message'),
          actions: [
            TextButton(
              child: Text('OK'),
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
                  borderRadius: BorderRadius.only(
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
                        icon: Icon(Icons.arrow_back,
                            color: Colors.white, size: 30.0),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Center(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Cadastre-se como Babá',
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
                  padding: EdgeInsets.all(16.0),
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
                          label: 'Experiência (em anos)',
                          icon: Icons.timer,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              experienceTime = value!;
                            });
                          },
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Por favor, digite seu tempo de experiência'
                                : null;
                          },
                        ),
                        _buildTextField(
                          label: 'Data de Nascimento (DD/MM/AAAA)',
                          icon: Icons.calendar_today,
                          keyboardType: TextInputType.datetime,
                          controller: birthDateController,
                          onChanged: (value) {
                            setState(() {
                              birthDate = _parseDate(value!) ?? DateTime.now();
                            });
                          },
                          validator: (value) {
                            return _validateDate(value);
                          },
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // Save the form data
                              _formKey.currentState!.save();
                              // Process the sign-up data here
                              await _registerBabysitter();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _cursorColor,
                            elevation: 5,
                            padding: EdgeInsets.symmetric(
                                vertical: 14.0, horizontal: 24.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: Text(
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
                    padding: EdgeInsets.all(20.0),
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(
                          255, 255, 215, 229), // Cor de fundo do container
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Cadastro realizado com sucesso!',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showPopup = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _cursorColor,
                            elevation: 5,
                            padding: EdgeInsets.symmetric(
                                vertical: 14.0, horizontal: 24.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: Text(
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
}
