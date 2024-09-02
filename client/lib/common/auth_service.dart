import 'package:client/common/api_service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
      List<String> parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('Token JWT inválido');
      }
      String payloadBase64 = parts[1];
      String normalizedBase64 = base64Url.normalize(payloadBase64);
      String decodedPayload = utf8.decode(base64Url.decode(normalizedBase64));
      Map<String, dynamic> payloadMap = json.decode(decodedPayload);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', payloadMap['user_id']);

      await prefs.setString('jwt_token', token);

      List<String> roles = List<String>.from(response['roles']);
      if (token != null) {
        ApiService.setAuthorizationTokenAndRoles(token, roles);
        setCurrentProfileType(roles[0]);
        return token;
      } else {
        throw Exception('Token not found in response');
      }
    } catch (e) {
      print('Error during login: $e');
      rethrow;
    }
  }

  static void navigateToEditProfile(BuildContext context) {
    if (_currentProfileType == 'babysitter') {
      Navigator.of(context).pushNamed('/babysitter_edit');
    } else if (_currentProfileType == 'tutor') {
      Navigator.of(context).pushNamed('/tutor_edit');
    } else {
      print('Tipo de perfil desconhecido: $_currentProfileType');
    }
  }
  static void setCurrentProfileType(String profileType) async {
    _currentProfileType = profileType;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_type', profileType);
  }

  static Future<String> getCurrentProfileType() async {
    if (_currentProfileType.isEmpty) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _currentProfileType = prefs.getString('profile_type') ?? '';
    }
    return _currentProfileType;
  }

  static void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
