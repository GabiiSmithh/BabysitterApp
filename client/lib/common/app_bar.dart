import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackButtonPressed;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onBackButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 182, 46, 92),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onBackButtonPressed ?? () {
          Navigator.of(context).pop();
        },
      ),
      actions: [
        PopupMenuButton<String>(
          icon: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person,
                color: Color.fromARGB(255, 235, 29, 98), size: 24.0),
          ),
          onSelected: (String value) {
            switch (value) {
              case 'profile':
                Navigator.of(context).pushNamed('/profile');
                break;
              case 'services':
                Navigator.of(context).pushNamed('/my-services');
                break;
              case 'settings':
                Navigator.of(context).pushNamed('/settings');
                break;
              case 'logout':
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

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
