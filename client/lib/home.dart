import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:client/common/api_service.dart'; // Importa o ApiService
import 'package:client/babysitting-services/list_services_screen.dart';
import 'package:client/babysitting-services/create_service_screen.dart';
import 'package:client/babysitter/screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Babysitter App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color _cursorColor = Color.fromARGB(255, 182, 46, 92); // Cor magenta
  bool _isBabysitter = false; // Controle dos check-marks
  bool _isTutor = false; // Controle dos check-marks
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final response = await ApiService.post(
        '/auth/login', // Caminho para o endpoint de login
        {
          'email': email,
          'password': password,
        },
      );

      final userRole =
          response['role']; // Supondo que a resposta inclui o papel do usuário

      if (_isBabysitter && userRole == 'babysitter') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BabysittingRequestsPage(),
          ),
        );
      } else if (_isTutor && userRole == 'tutor') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CreateServicePage(),
          ),
        );
      } else {
        // Se o papel retornado não corresponder ao selecionado, exiba uma mensagem de erro
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Erro'),
            content: Text('Tipo de usuário inválido ou não selecionado.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Exibe uma mensagem de erro
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro'),
          content: Text('Falha na autenticação. Verifique suas credenciais.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 255, 215, 229), // Define o fundo rosa bebê
      body: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: _cursorColor, // Cor magenta
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(
                    100.0), // Arredonda o canto inferior esquerdo
                bottomRight: Radius.circular(
                    0.0), // Remove o arredondamento do canto inferior direito
              ),
            ),
            height: MediaQuery.of(context).size.height *
                0.4, // Ajusta a altura para ocupar mais espaço
            width: double.infinity, // Ocupa toda a largura da tela
            child: Center(
              child: Container(
                width: 150.0, // Largura do fundo circular
                height: 150.0, // Altura do fundo circular
                decoration: BoxDecoration(
                  color: Colors.white, // Fundo branco
                  shape: BoxShape.circle, // Forma circular
                ),
                child: Center(
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: 10.0, sigmaY: 10.0), // Desfoca a imagem
                      child: Image.asset(
                        'images/babysitter.png', // Caminho para a sua imagem
                        width: 150.0, // Largura da imagem
                        height: 150.0, // Altura da imagem
                        fit: BoxFit
                            .cover, // Ajusta a imagem para cobrir o círculo
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                children: <Widget>[
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.only(bottom: 10.0),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26, // Cor da sombra
                          blurRadius: 10.0, // Desfoque da sombra
                          offset: Offset(2,
                              4), // Deslocamento da sombra (abaixo e para a direita)
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _emailController,
                      cursorColor: _cursorColor, // Define a cor do cursor
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email), // Ícone de email
                        labelText: 'Email',
                        labelStyle: TextStyle(
                            color: Colors.grey[600]), // Cor da label padrão
                        filled: true, // Habilita a cor de fundo
                        fillColor: Colors.grey[200], // Cor de fundo cinza claro
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              30.0), // Arredonda as bordas
                          borderSide: BorderSide.none, // Remove a borda padrão
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              30.0), // Arredonda as bordas
                          borderSide: BorderSide(
                              color:
                                  _cursorColor), // Borda magenta quando em foco
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              30.0), // Arredonda as bordas
                          borderSide: BorderSide.none, // Remove a borda padrão
                        ),
                      ),
                      style: TextStyle(color: Colors.black), // Cor do texto
                    ),
                  ),
                  SizedBox(height: 10.0), // Espaçamento entre os campos
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26, // Cor da sombra
                          blurRadius: 10.0, // Desfoque da sombra
                          offset: Offset(2,
                              4), // Deslocamento da sombra (abaixo e para a direita)
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _passwordController,
                      cursorColor: _cursorColor, // Define a cor do cursor
                      obscureText: true, // Oculta o texto para o campo de senha
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock), // Ícone de senha
                        labelText: 'Senha',
                        labelStyle: TextStyle(
                            color: Colors.grey[600]), // Cor da label padrão
                        filled: true, // Habilita a cor de fundo
                        fillColor: Colors.grey[200], // Cor de fundo cinza claro
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              30.0), // Arredonda as bordas
                          borderSide: BorderSide.none, // Remove a borda padrão
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              30.0), // Arredonda as bordas
                          borderSide: BorderSide(
                              color:
                                  _cursorColor), // Borda magenta quando em foco
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              30.0), // Arredonda as bordas
                          borderSide: BorderSide.none, // Remove a borda padrão
                        ),
                      ),
                      style: TextStyle(color: Colors.black), // Cor do texto
                    ),
                  ),
                  SizedBox(height: 20.0), // Espaçamento antes dos checkboxes
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                              value: _isBabysitter,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isBabysitter = value ?? false;
                                  if (_isBabysitter) {
                                    _isTutor =
                                        false; // Desmarca o outro checkbox
                                  }
                                });
                              },
                              activeColor: _cursorColor,
                              checkColor: Colors.white,
                            ),
                            Text('Babá'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                              value: _isTutor,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isTutor = value ?? false;
                                  if (_isTutor) {
                                    _isBabysitter =
                                        false; // Desmarca o outro checkbox
                                  }
                                });
                              },
                              activeColor: _cursorColor,
                              checkColor: Colors.white,
                            ),
                            Text('Tutor'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0), // Espaçamento antes do botão
                  ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _cursorColor,
                      padding: EdgeInsets.symmetric(
                          vertical: 25.0,
                          horizontal:
                              40.0), // Aumente esses valores para deixar o botão mais gordinho
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30.0), // Arredonda as bordas
                      ),
                    ),
                    child: Text(
                      'Fazer Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0, // Tamanho da fonte
                      ),
                    ),
                  ),

                  Spacer(), // Empurra o texto para baixo
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Ainda não possui uma conta?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BabysitterSignUpPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Cadastrar-se como Babá',
                                  style: TextStyle(
                                    color: _cursorColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationColor: _cursorColor,
                                    decorationThickness: 2.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              'ou',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //context,
                                  //MaterialPageRoute(
                                  //builder: (context) => ResponsibleSignUpPage(),
                                  // ),
                                  //);
                                },
                                child: Text(
                                  'Cadastrar-se como Responsável',
                                  style: TextStyle(
                                    color: _cursorColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationColor: _cursorColor,
                                    decorationThickness: 2.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
