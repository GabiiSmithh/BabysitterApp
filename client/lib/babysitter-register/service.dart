import 'package:client/common/api_service.dart';
import 'package:client/common/auth_service.dart';

class BabySitterRegisterService {
  static Future createBabySitter(
    payload,
  ) async {
    try {
      await ApiService.post('babysitters', payload);
      AuthService.setCurrentProfileType('babysitter');
    } catch (e) {
      print('Error creating BabySitter: $e');
      rethrow;
    }
  }
}
