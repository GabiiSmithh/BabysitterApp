import 'package:client/common/api_service.dart';

class BabySitterRegisterService {
  static Future createBabySitter(
    payload,
  ) async {
    try {
      await ApiService.post('babysitters', payload);
    } catch (e) {
      print('Error creating BabySitter: $e');
      rethrow;
    }
  }
}
