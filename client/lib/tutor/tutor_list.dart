import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class TutorListPage extends StatefulWidget {
  const TutorListPage({super.key});

  @override
  _TutorListPageState createState() => _TutorListPageState();
}

class _TutorListPageState extends State<TutorListPage> {
  final Color _backgroundColor =
      const Color.fromARGB(255, 255, 215, 229); // Rosa claro
  final Color _cardColor = const Color.fromARGB(255, 255, 255, 255); // Branco
  final Color _primaryColor = const Color.fromARGB(255, 182, 46, 92); // Magenta

  List<dynamic> Tutors = [];

  @override
  void initState() {
    super.initState();
    _fetchTutors();
  }

  Future<void> _fetchTutors() async {
    final url = Uri.parse('http://201.23.18.202:3333/tutors');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        Tutors = json.decode(response.body);
      });
    } else {
      print('Failed to load Tutors');
    }
  }

  Future<void> _updateTutor(String id, Map<String, dynamic> data) async {
    final url = Uri.parse('http://201.23.18.202:3333/tutors/$id');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      _fetchTutors();
      _showSuccessSnackBar('Tutor atualizado com sucesso!');
    } else {
      String errorMessage;
      try {
        final responseBody = response.body;
        final errorJson = json.decode(responseBody);
        errorMessage = errorJson['error'] ?? 'Erro desconhecido';
      } catch (e) {
        errorMessage = 'Erro ao processar a resposta do servidor.';
      }
      _showErrorDialog(errorMessage);
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Text(errorMessage),
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

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tutores'),
        backgroundColor: _primaryColor,
      ),
      backgroundColor: _backgroundColor,
      body: ListView.builder(
        itemCount: Tutors.length,
        itemBuilder: (context, index) {
          final Tutor = Tutors[index];
          return Card(
            color: _cardColor,
            margin: const EdgeInsets.all(16.0),
            elevation: 5,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(
                Tutor['name'],
                style: TextStyle(
                  color: _primaryColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Gênero: ${Tutor['gender']}'),
                  Text('Email: ${Tutor['email']}'),
                  Text('Telefone: ${Tutor['cellphone']}'),
                  Text('Data de Nascimento: ${Tutor['birthDate']}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: _primaryColor),
                    onPressed: () {
                      _showUpdateDialog(Tutor['id']);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteConfirmationDialog(Tutor['id']);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showUpdateDialog(String id) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final genderController = TextEditingController();
    final phoneController = MaskedTextController(mask: '(00)00000-0000');
    final  addressController= TextEditingController();
    final  numberOfChildrenController= TextEditingController();



    // Preencher os campos com os valores atuais
    final Tutor = Tutors.firstWhere((b) => b['id'] == id);
    nameController.text = Tutor['name'];
    emailController.text = Tutor['email'];
    genderController.text = Tutor['gender'];
    phoneController.text = Tutor['cellphone'];
    addressController.text = Tutor['address'];
    numberOfChildrenController.text = Tutor['childrenCount'].toString();
    //print(Tutor);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 215, 229),
          title: const Text('Atualizar Tutor'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(
                    controller: nameController,
                    label: 'Nome',
                    icon: Icons.person,
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
                        genderController.text = value!;
                      });
                    },
                    validator: (value) {
                      return value == null
                          ? 'Por favor, selecione seu gênero'
                          : null;
                    },
                  ),
                  _buildTextField(
                    controller: emailController,
                    label: 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      return _validateEmail(value);
                    },
                  ),
                  _buildTextField(
                    controller: phoneController,
                    label: 'Telefone',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      return _validatePhoneNumber(value);
                    },
                  ),
                  _buildTextField(
                    controller: addressController,
                    label: 'Endereço',
                    icon: Icons.home,
                    validator: (value) {
                      return value!.isEmpty
                          ? 'Por favor, digite seu Endereço'
                          : null;
                    },
                  ),
                  _buildTextField(
                    controller: numberOfChildrenController,
                    label: 'Número de Filhos',
                    icon: Icons.child_care_rounded,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      return value!.isEmpty
                          ? 'Por favor, digite quantidade de filhos'
                          : null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final updatedData = {
                    'name': nameController.text,
                    'email': emailController.text,
                    'gender': genderController.text,
                    'cellphone':
                        phoneController.text.replaceAll(RegExp(r'[^\d]'), ''),
                    'address': addressController.text,
                    'children_count': int.tryParse(numberOfChildrenController.text) ?? 0,
                  };
                  _updateTutor(id, updatedData);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Tem certeza de que deseja excluir esta Tutor?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Excluir'),
              onPressed: () {
                //TO DO - CRIAR E CHAMAR FUNCAO DE DELETE
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  

  String? _validateEmail(String? value) {
    final emailRegExp = RegExp(r'^[^\s@]+@[^\s@]+$');
    if (value == null || value.isEmpty) {
      return 'Por favor, digite seu email';
    }
    if (!emailRegExp.hasMatch(value)) {
      return 'Email inválido';
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

  bool _validateForm(Map<String, dynamic> data) {
    final emailValidation = _validateEmail(data['email']);
    final phoneValidation = _validatePhoneNumber(data['cellphone']);
    return emailValidation == null && phoneValidation == null;
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    required FormFieldValidator<String> validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
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
