import 'dart:ui';
import 'package:client/common/auth_service.dart';
import 'package:flutter/material.dart';
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
  final Color _cursorColor = Color.fromARGB(255, 182, 46, 92); 
  bool _isBabysitter = false; 
  bool _isTutor = false; 
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await AuthService.login(
        email,
        password,
      );

      if (_isBabysitter) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BabysittingRequestsPage(),
          ),
        );
      } else if (_isTutor) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CreateServicePage(),
          ),
        );
      } else {
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
          const Color.fromARGB(255, 255, 215, 229),
      body: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: _cursorColor, 
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(
                    100.0),
                bottomRight: Radius.circular(
                    0.0), 
              ),
            ),
            height: MediaQuery.of(context).size.height *
                0.4,
            width: double.infinity, 
            child: Center(
              child: Container(
                width: 150.0, 
                height: 150.0, 
                decoration: BoxDecoration(
                  color: Colors.white, 
                  shape: BoxShape.circle, 
                ),
                child: Center(
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: 10.0, sigmaY: 10.0), 
                      child: Image.asset(
                        'images/babysitter.png', 
                        width: 150.0, 
                        height: 150.0,
                        fit: BoxFit
                            .cover, 
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
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 10.0),
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26, 
                          blurRadius: 10.0, 
                          offset: Offset(2,
                              4), 
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _emailController,
                      cursorColor: _cursorColor, 
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email), 
                        labelText: 'Email',
                        labelStyle: TextStyle(
                            color: Colors.grey[600]), 
                        filled: true,
                        fillColor: Colors.grey[200], 
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              30.0), 
                          borderSide: BorderSide.none, 
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              30.0),
                          borderSide: BorderSide(
                              color:
                                  _cursorColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              30.0), 
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(color: Colors.black), 
                    ),
                  ),
                  SizedBox(height: 10.0),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0, 
                          offset: Offset(2,
                              4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _passwordController,
                      cursorColor: _cursorColor,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock), 
                        labelText: 'Senha',
                        labelStyle: TextStyle(
                            color: Colors.grey[600]),
                        filled: true, 
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              30.0),
                          borderSide: BorderSide.none, 
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              30.0), 
                          borderSide: BorderSide(
                              color:
                                  _cursorColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              30.0), 
                          borderSide: BorderSide.none, 
                        ),
                      ),
                      style: TextStyle(color: Colors.black), 
                    ),
                  ),
                  SizedBox(height: 20.0), 
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
                                        false; 
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
                                        false; 
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
                  SizedBox(height: 20.0), 
                  ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _cursorColor,
                      padding: EdgeInsets.symmetric(
                          vertical: 25.0,
                          horizontal:
                              40.0), 
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30.0), 
                      ),
                    ),
                    child: Text(
                      'Fazer Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0, 
                      ),
                    ),
                  ),

                  Spacer(), 
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
