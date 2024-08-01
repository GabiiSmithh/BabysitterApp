import 'package:flutter/material.dart';
import 'dart:ui'; // Importar para usar ImageFilter

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
                        'assets/images/babysitter.png', // Caminho para a sua imagem
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
                        labelText: 'Password',
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
                  SizedBox(height: 20.0), // Espaçamento antes do botão
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 80.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Ação do botão
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _cursorColor, // Define a cor sólida do botão
                        elevation: 0, // Remove a elevação do botão
                        padding: EdgeInsets.symmetric(
                            vertical: 12.0), // Ajusta o padding interno
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20.0), // Borda arredondada
                        ),
                        minimumSize: Size(100, 50), // Tamanho mínimo do botão
                        side: BorderSide.none, // Remove a borda do botão
                      ).copyWith(
                        shadowColor: MaterialStateProperty.all(
                            Colors.transparent), // Remove a sombra padrão
                      ),
                      child: Text(
                        'Fazer Login',
                        style: TextStyle(
                          color: Colors.white, // Cor do texto do botão
                          fontSize: 14.0, // Tamanho da fonte
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
                          // Ação ao clicar
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
