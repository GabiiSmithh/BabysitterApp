import 'package:client/common/api_service.dart';
import 'package:client/common/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BabySitterRegisterService {
  static Future createBabySitter(
    payload,
  ) async {
    try {
      final response = await ApiService.post('babysitters', payload);
      AuthService.setCurrentProfileType('babysitter');
      ApiService.setRoles(['babysitter']);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', response['id']);

      final token = await AuthService.login(payload['email'], payload['password']);
      await prefs.setString('jwt_token', token);
    } catch (e) {
      print('Error creating BabySitter: $e');
      rethrow;
    }
  }
}
