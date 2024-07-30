import 'package:client/common/api_service.dart';

class BabySitterService {
  static Future createBabySitter(
    String name,
    String email,
    String gender,
    String password,
    String phone,
    String dateOfBirth,
    String experienceTime
  ) async {
    try {
      final payload = {
        'name': name,
        'email': email,
        'gender': gender,
        'password': password,
        'phone': phone,
        'date_of_birth': dateOfBirth,
        'experience_time': experienceTime
      };
      final response = await ApiService.post('babysitter', payload);
      return response['data'][0];
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
      final response = await ApiService.patch('babysitter/$id', payload);
      return response['data'][0];
    } catch (e) {
      print('Error updating BabySitter: $e');
      rethrow;
    }
  }
}
