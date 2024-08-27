import 'package:client/common/api_service.dart';

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
}
