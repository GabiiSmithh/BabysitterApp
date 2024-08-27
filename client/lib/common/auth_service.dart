import 'package:client/common/api_service.dart';
import 'package:flutter/material.dart';
import 'package:client/profile/babysitter_edit.dart'; // Importe a tela de edição de babá
import 'package:client/profile/tutor_edit.dart'; // Importe a tela de edição de tutor

class AuthService {
  static String _currentProfileType = '';

  static Future login(String email, String password) async {
    try {
      final payload = {
        'email': email,
        'password': password,
      };
      final response = await ApiService.post('auth/login', payload);
      final token = response['token'];
      // final roles = response['roles'];
      final roles = ['babysitter', 'tutor'];
      if (token != null) {
        ApiService.setAuthorizationTokenAndRoles(token, roles);
        return token;
      } else {
        throw Exception('Token not found in response');
      }
    } catch (e) {
      print('Error during login: $e');
      rethrow;
    }
  }

  static void setCurrentProfileType(String profileType) {
    _currentProfileType = profileType;
  }

  static String getCurrentProfileType() {
    return _currentProfileType;
  }

  static void navigateToEditProfile(BuildContext context) {
    final profileType = getCurrentProfileType().trim(); // Remove espaços em branco
    Widget editScreen;

    print('Navigating to edit profile, current profile type: $profileType'); // Debug

    if (profileType == 'Babá' || profileType == 'babysitter') {
      editScreen = BabysitterEditScreen(); // Substitua pelo nome correto da tela
    } else if (profileType == 'Responsável' || profileType == 'tutor') {
      editScreen = TutorEditScreen(); // Substitua pelo nome correto da tela
    } else {
      print('Unknown profile type, navigating to default'); // Debug
      // Opcional: Redirecionar para uma tela de erro ou uma página padrão
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => editScreen,
      ),
    );
  }
}
