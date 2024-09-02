import 'package:client/common/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:client/common/api_service.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackButtonPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackButtonPressed,
  });

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
    if (_currentProfileType == 'Babá') {
      AuthService.setCurrentProfileType('Responsável');
      Navigator.of(context).pushNamed('/services');
    } else {
      AuthService.setCurrentProfileType('Babá');
      Navigator.of(context).pushNamed('/requests');
    }
    _initializeProfileType(); // Update after switching profile
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
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: widget.onBackButtonPressed ??
            () {
              Navigator.of(context).pop();
            },
      ),
      actions: [
        if (_hasBothRoles)
          TextButton(
            onPressed: () {
              _switchProfile(context);
            },
            child: Text(
              _currentProfileType == 'Babá'
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
              case 'profile':
                Navigator.of(context).pushNamed('/profile');
                break;
              case 'my-services':
                Navigator.of(context).pushNamed('/my-services');
                break;
              case 'settings':
                Navigator.of(context).pushNamed('/settings');
                break;
              case 'logout':
                Navigator.of(context).pushNamed('/login');
                break;
              case 'services-provided':
                Navigator.of(context).pushNamed('/services-provided');
                break;
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem<String>(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.person,
                      color: Color.fromARGB(255, 182, 46, 92)),
                  title: Text('Seu perfil'),
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
              const PopupMenuItem<String>(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings,
                      color: Color.fromARGB(255, 182, 46, 92)),
                  title: Text('Configurações da conta'),
                ),
              ),
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
