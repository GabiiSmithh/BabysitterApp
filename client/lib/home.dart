import 'package:client/babysitting-services/list_services_screen.dart';
import 'package:client/babysitting-services/create_service_screen.dart'; // Adicionado para o tutor
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
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
  bool _isMouseOverBabysitter = false;
  bool _isMouseOverParent = false;
  bool _isBabysitter = false; // Adicionado para controle dos check-marks
  bool _isTutor = false; // Adicionado para controle dos check-marks

  void _showLoginPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor:
              Color.fromARGB(255, 255, 203, 214), // Cor rosa para o container
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Parabéns!!'),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Login realizado com sucesso!'),
              SizedBox(height: 10.0), // Espaçamento entre as linhas
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Para acessar os cadastros, ',
                      style: TextStyle(color: Colors.black), // Cor do texto
                    ),
                    TextSpan(
                      text: 'clique aqui',
                      style: TextStyle(
                        color: _cursorColor, // Cor do link
                        decoration: TextDecoration.underline, // Sublinhado
                        fontWeight: FontWeight.bold, // Destaca o texto
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => _isBabysitter
                                  ? BabysittingRequestsPage()
                                  : CreateServicePage(), // Ajusta para a página correta
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleLogin() {
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
      // Talvez exibir uma mensagem de erro ou alerta
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
                  SizedBox(
                      height:
                          10.0), // Espaçamento entre os campos e os check-marks
                  Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Centraliza os check-marks
                      children: <Widget>[
                        CheckboxListTile(
                          title: Text('Entrar como Babá'),
                          value: _isBabysitter,
                          onChanged: (bool? value) {
                            setState(() {
                              _isBabysitter = value ?? false;
                              if (_isBabysitter) {
                                _isTutor = false;
                              }
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          dense: true, // Torna o check-box menor
                          activeColor: Color.fromARGB(255, 182, 46, 92),
                          checkColor: Colors.white,
                        ),
                        CheckboxListTile(
                          title: Text('Entrar como Responsável'),
                          value: _isTutor,
                          onChanged: (bool? value) {
                            setState(() {
                              _isTutor = value ?? false;
                              if (_isTutor) {
                                _isBabysitter = false;
                              }
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          dense: true, // Torna o check-box menor
                          activeColor: Color.fromARGB(255, 182, 46, 92),
                          checkColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0, // Espaçamento entre os check-marks e o botão
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: 60.0), // Ajusta a largura do botão
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _cursorColor,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                            vertical: 18.0), // Botão "mais gordinho"
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        minimumSize: Size(double.infinity, 50),
                        side: BorderSide.none,
                      ).copyWith(
                        shadowColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: Text(
                        'Fazer Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0, // Tamanho da fonte do botão
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Ainda não possui uma conta?',
                  style: TextStyle(
                    color: Colors.black, // Cor do texto
                    fontSize: 16.0, // Tamanho da fonte
                    fontWeight: FontWeight.bold, // Destaca o texto
                  ),
                ),
                SizedBox(height: 10.0), // Espaçamento entre o texto e os links
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          _isMouseOverBabysitter = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          _isMouseOverBabysitter = false;
                        });
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BabysitterSignUpPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Cadastrar-se como Babá',
                          style: TextStyle(
                            color: _cursorColor, // Cor do texto clicável
                            fontSize: 16.0, // Tamanho da fonte
                            fontWeight: FontWeight.bold, // Destaca o texto
                            decoration: _isMouseOverBabysitter
                                ? TextDecoration.underline
                                : TextDecoration.none,
                            decorationColor: _cursorColor, // Cor do sublinhado
                            decorationThickness: 2.0, // Espessura do sublinhado
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0), // Espaçamento entre os links
                    Text(
                      'ou',
                      style: TextStyle(
                        color: Colors.black, // Cor do texto
                        fontSize: 16.0, // Tamanho da fonte
                        fontWeight: FontWeight.bold, // Destaca o texto
                      ),
                    ),
                    SizedBox(width: 10.0), // Espaçamento entre os links
                    MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          _isMouseOverParent = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          _isMouseOverParent = false;
                        });
                      },
                      child: GestureDetector(
                        onTap: () {
                          // Ação ao clicar
                        },
                        child: Text(
                          'Cadastrar-se como Responsável',
                          style: TextStyle(
                            color: _cursorColor, // Cor do texto clicável
                            fontSize: 16.0, // Tamanho da fonte
                            fontWeight: FontWeight.bold, // Destaca o texto
                            decoration: _isMouseOverParent
                                ? TextDecoration.underline
                                : TextDecoration.none,
                            decorationColor: _cursorColor, // Cor do sublinhado
                            decorationThickness: 2.0, // Espessura do sublinhado
                          ),
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
    );
  }
}
