import 'package:client/common/api_service.dart';

class TutorProfileService {
  static Future fetchData(String userId) async {
    try {
      final response = await ApiService.get('tutors/$userId');
      return response;
    } catch (e) {
      print('Error fetching Tutor Data: $e');
      rethrow;
    }
  }

  static Future updateTutorProfile(String userId, payload) async {
    try {
      final input = {
        'email': payload['email'],
        'cellphone': payload['cellphone'],
        'children_count': payload['childrenCount'],
        'address': payload['address'],
      };
      final response = await ApiService.patch('tutors/$userId', input);
      return response;
    } catch (e) {
      print('Error updating Tutor Profile: $e');
      rethrow;
    }
  }
}
