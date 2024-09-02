import 'package:client/common/api_service.dart';
import 'package:client/common/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorRegisterService {
  static Future createTutor(
    payload,
  ) async {
    try {
      final response = await ApiService.post('tutors', payload);
      AuthService.setCurrentProfileType('tutor');
      ApiService.setRoles(['tutor']);

      final token = await AuthService.login(payload['email'], payload['password']);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', response['id']);
      await prefs.setString('jwt_token', token);
    } catch (e) {
      print('Error creating BabySitter: $e');
      rethrow;
    }
  }
}
