import 'package:flutter/material.dart';
import 'package:client/common/auth_service.dart';
import 'package:client/common/api_service.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackButtonPressed;

  const CustomAppBar(
      {super.key, required this.title, this.onBackButtonPressed});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _hasBothRoles = false;
  String _currentProfileType = "";

  @override
  void initState() {
    super.initState();
    _initializeProfileType();
    _checkRoles();
  }

  void _initializeProfileType() async {
    final profileType = await AuthService.getCurrentProfileType();
    setState(() {
      _currentProfileType = profileType;
    });
  }

  void _checkRoles() async {
    try {
      final roles = await ApiService.getRoles();
      setState(() {
        _hasBothRoles = roles.contains('babysitter') && roles.contains('tutor');
      });
    } catch (e) {
      print('Error fetching roles: $e');
    }
  }

  void _switchProfile(BuildContext context) async {
    if (_currentProfileType == 'babysitter') {
      AuthService.setCurrentProfileType('tutor');
      Navigator.of(context).pushReplacementNamed('/services');
    } else {
      AuthService.setCurrentProfileType('babysitter');
      Navigator.of(context).pushReplacementNamed('/requests');
    }
    _initializeProfileType();
  }

  void _navigateHome() {
    if (_currentProfileType == 'babysitter') {
      Navigator.of(context).pushNamed('/requests');
    } else {
      Navigator.of(context).pushNamed('/services');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 182, 46, 92),
      title: Text(
        widget.title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.home, color: Colors.white),
        onPressed: _navigateHome,
      ),
      actions: [
        if (_hasBothRoles)
          TextButton(
            onPressed: () {
              _switchProfile(context);
            },
            child: Text(
              _currentProfileType == 'babysitter'
                  ? 'Trocar para Responsável'
                  : 'Trocar para Babá',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        PopupMenuButton<String>(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person,
                color: Color.fromARGB(255, 235, 29, 98), size: 24.0),
          ),
          onSelected: (String value) {
            switch (value) {
              case 'babysitter-profile':
                Navigator.of(context).pushNamed('/babysitter-profile');
                break;
              case 'tutor-profile':
                Navigator.of(context).pushNamed('/tutor-profile');
                break;
              case 'my-services':
                Navigator.of(context).pushNamed('/my-services');
                break;
              case 'settings':
                Navigator.of(context).pushNamed('/settings');
                break;
              case 'logout':
                AuthService.logout();
                Navigator.of(context).pushNamed('/login');
                break;
              case 'services-provided':
                Navigator.of(context).pushNamed('/services-provided');
                break;
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: _currentProfileType == 'babysitter'
                    ? 'babysitter-profile'
                    : 'tutor-profile',
                child: const ListTile(
                  leading: Icon(Icons.person,
                      color: Color.fromARGB(255, 182, 46, 92)),
                  title: Text('Meu perfil'),
                ),
              ),
              PopupMenuItem<String>(
                value: (_currentProfileType == 'babysitter'
                    ? 'services-provided'
                    : 'my-services'),
                child: ListTile(
                  leading: const Icon(Icons.history,
                      color: Color.fromARGB(255, 182, 46, 92)),
                  title: Text(_currentProfileType == 'babysitter'
                      ? 'Serviços já prestados'
                      : 'Meus serviços'),
                ),
              ),
              // const PopupMenuItem<String>(
              //   value: 'settings',
              //   child: ListTile(
              //     leading: Icon(Icons.settings,
              //         color: Color.fromARGB(255, 182, 46, 92)),
              //     title: Text('Configurações da conta'),
              //   ),
              // ),
              const PopupMenuItem<String>(
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
        const SizedBox(width: 16.0),
      ],
    );
  }
}
