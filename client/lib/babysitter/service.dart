import 'package:client/common/api_service.dart';

class BabySitterService {
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

  static Future updateBabySitter(String id, String phone, String experienceTime) async {
    try {
      final payload = {
        'phone': phone,
        'experience_time': experienceTime
      };
      final response = await ApiService.patch('babysitters/$id', payload);
      return response['data'][0];
    } catch (e) {
      print('Error updating BabySitter: $e');
      rethrow;
    }
  }
}
