import 'package:client/common/api_service.dart';

class TutorProfileService {
  static Future fetchData(String userId) async {
    try {
      final response = await ApiService.get('tutors/$userId');
      return response;
    } catch (e) {
      print('Error during login: $e');
      rethrow;
    }
  }
}
