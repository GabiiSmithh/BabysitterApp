import 'package:flutter/material.dart';
import 'package:client/common/auth_service.dart';
import 'package:client/common/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackButtonPressed;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onBackButtonPressed,
  }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
class _CustomAppBarState extends State<CustomAppBar> {
  bool _hasBothRoles = false;

  @override
  void initState() {
    super.initState();
    _checkRoles();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkRoles();  // Re-verifica as roles quando as dependências mudam
  }

  void _checkRoles() async {
    try {
      final roles = await ApiService.getRoles();  // Adicione await se getRoles for assíncrono
      setState(() {
        _hasBothRoles = roles.contains('babysitter') && roles.contains('tutor');
      });
    } catch (e) {
      print('Error fetching roles: $e');
    }
  }

  void _switchProfile(BuildContext context) {
    setState(() {
      if (AuthService.getCurrentProfileType() == 'babysitter') {
        AuthService.setCurrentProfileType('tutor');
        Navigator.of(context).pushNamed('/services');
      } else {
        AuthService.setCurrentProfileType('babysitter');
        Navigator.of(context).pushNamed('/requests');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    return AppBar(
      backgroundColor: Color.fromARGB(255, 182, 46, 92),
      title: Text(
        widget.title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: currentRoute == '/services' || currentRoute == '/requests' || currentRoute == ''
        ? SizedBox() // Um widget vazio para desabilitar o botão de voltar
        : IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              } else {
                // Se não há nada para voltar, não faz nada
              }
            },
          ),
      actions: [
        if (_hasBothRoles)
          TextButton(
            onPressed: () {
              _switchProfile(context);
            },
            child: Text(
              AuthService.getCurrentProfileType() == 'babysitter'
                  ? 'Trocar para Tutor'
                  : 'Trocar para Babá',
              style: TextStyle(color: Colors.white),
            ),
          ),
        PopupMenuButton<String>(
          icon: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person,
                color: Color.fromARGB(255, 235, 29, 98), size: 24.0),
          ),
          onSelected: (String value) async {
            switch (value) {
              case 'profile':
                Navigator.of(context).pushNamed('/profile');
                break;
              case 'services':
                Navigator.of(context).pushNamed('/my-services');
                break;
              case 'settings':
                AuthService.navigateToEditProfile(context); // Atualize aqui para chamar o método correto
                break;
              case 'logout':
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();  // Limpa todos os dados armazenados
                Navigator.of(context).pushNamed('/login');
                break;
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.person,
                      color: Color.fromARGB(255, 182, 46, 92)),
                  title: Text('Seu perfil'),
                ),
              ),
              PopupMenuItem<String>(
                value: 'services',
                child: ListTile(
                  leading: Icon(Icons.history,
                      color: Color.fromARGB(255, 182, 46, 92)),
                  title: Text('Serviços já prestados'),
                ),
              ),
              PopupMenuItem<String>(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings,
                      color: Color.fromARGB(255, 182, 46, 92)),
                  title: Text('Configurações da conta'),
                ),
              ),
              PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout,
                      color: Color.fromARGB(255, 182, 46, 92)),
                  title: Text('Sair da conta'),
                ),
              ),
            ];
          },
        ),
        SizedBox(width: 16.0),
      ],
    );
  }
}
