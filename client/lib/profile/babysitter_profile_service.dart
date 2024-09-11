import 'package:client/common/api_service.dart';

class BabysitterProfileService {
  static Future fetchData(String userId) async {
    try {
      final response = await ApiService.get('babysitters/$userId');
      return response;
    } catch (e) {
      print('Error during fetch Babysitter Data: $e');
      rethrow;
    }
  }

  static Future updateBabysitterProfile(String userId, payload) async {
    try {
      final input = {
        'email': payload['email'],
        'cellphone': payload['cellphone'],
        'experience_months': payload['experienceMonths'],
      };
      final response = await ApiService.patch('babysitters/$userId', input);
      return response;
    } catch (e) {
      print('Error during login: $e');
      rethrow;
    }
  }
}
