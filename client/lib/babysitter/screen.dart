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

  final phoneController = MaskedTextController(mask: '(00) 00000-0000');
  final birthDateController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 215, 229),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 70.0,
            decoration: BoxDecoration(
              color: _topContainerColor, // Cor sólida
              borderRadius: BorderRadius.only(
                bottomLeft:
                    Radius.circular(50.0), // Extremidade esquerda arredondada
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 16.0,
                  top: 12.0,
                  child: IconButton(
                    icon:
                        Icon(Icons.arrow_back, color: Colors.white, size: 30.0),
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
                          name = value;
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
                          email = value;
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
                          password = value;
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
                          confirmPassword = value;
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
                          phoneNumber = value;
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
                          experienceTime = value;
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
                          birthDate = _parseDate(value) ?? DateTime.now();
                        });
                      },
                      validator: (value) {
                        return _validateDate(value);
                      },
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Save the form data
                          _formKey.currentState!.save();
                          // Process the sign-up data here
                          print('Nome: $name');
                          print('Gênero: $gender');
                          print('Email: $email');
                          print('Senha: $password');
                          print('Telefone: $phoneNumber');
                          print('Experiência: $experienceTime');
                          print('Data de Nascimento: $birthDate');
                          // Show success message or navigate to another page
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
    );
  }

  Widget _buildTextField({
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onChanged,
    required String? Function(String?) validator,
    required IconData icon,
    TextEditingController? controller,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), // Cor do sombreado
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 5), // Deslocamento do sombreado
            ),
          ],
        ),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey[700]),
            filled: true,
            fillColor: Colors.grey[200],
            prefixIcon: Icon(icon, color: _cursorColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(color: _cursorColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
            ),
          ),
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          validator: validator,
          style: TextStyle(color: Colors.black),
          cursorColor: _cursorColor,
          controller: controller,
          inputFormatters: inputFormatters,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required List<String> items,
    required Function(String?) onChanged,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), // Cor do sombreado
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 5), // Deslocamento do sombreado
            ),
          ],
        ),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey[700]),
            filled: true,
            fillColor: Colors.grey[200],
            prefixIcon: Icon(Icons.arrow_drop_down, color: _cursorColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(color: _cursorColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
            ),
          ),
          dropdownColor:
              Color.fromARGB(255, 255, 203, 214), // Cor de fundo do dropdown
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  String? _validatePhoneNumber(String? value) {
    final phonePattern = RegExp(r'^\(\d{2}\) \d{5}-\d{4}$');
    if (value == null || value.isEmpty) {
      return 'Por favor, digite seu telefone';
    }
    if (!phonePattern.hasMatch(value)) {
      return 'Número de telefone inválido';
    }
    return null;
  }

  String? _validateDate(String? value) {
    final datePattern = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (value == null || value.isEmpty) {
      return 'Por favor, digite sua data de nascimento';
    }
    if (!datePattern.hasMatch(value)) {
      return 'Data inválida. Use o formato DD/MM/AAAA';
    }
    return null;
  }

  DateTime? _parseDate(String value) {
    try {
      final parts = value.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      // Handle parsing error
    }
    return null;
  }
}
