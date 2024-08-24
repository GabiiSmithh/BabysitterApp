
import 'package:client/common/api_service.dart';

class AuthService {
  static Future login(String email, String password) async {
    try {
      final payload = {
        'email': email,
        'password': password,
      };
      final response = await ApiService.post('auth/login', payload);
      final token = response['token']; 
      if (token != null) {
        ApiService.setAuthorizationToken(token);
        return token;
      } else {
        throw Exception('Token not found in response');
      }
    } catch (e) {
      print('Error during login: $e');
      rethrow; 
    }
  }
}