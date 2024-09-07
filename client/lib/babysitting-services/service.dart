import 'package:client/babysitting-services/model.dart';
import 'package:client/common/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BabySittingService {
  static Future<List<BabySittingServiceData>>
      getBabySittingServiceList() async {
    try {
      final response = await ApiService.get('services');

      if (response is List) {
        final List<BabySittingServiceData> services = response
            .map((json) => BabySittingServiceData.fromJson(json))
            .toList();
        return services;
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      print('Error fetching services list: $e');
      rethrow;
    }
  }

  static Future<void> createService(Map<String, dynamic> serviceData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString('user_id');

    try {
      final payload = {
        "tutor_id": userId,
        "start_date": serviceData['start_date'],
        "end_date": serviceData['end_date'],
        "value": serviceData['value'],
        "children_count": serviceData['children_count'],
        "address": serviceData['address'],
      };

      await ApiService.post(
        'services',
        payload,
      );
    } catch (e) {
      throw Exception('Error creating service: $e');
    }
  }

  static Future<void> updateService(
      String serviceId, Map<String, dynamic> serviceData) async {
    try {
      final payload = {
        "children_count": serviceData['children_count'],
        "address": serviceData['address'],
      };

      await ApiService.patch(
        'services/$serviceId',
        payload,
      );
    } catch (e) {
      throw Exception('Error updating service: $e');
    }
  }

  static Future<void> acceptService(String serviceId) async {
    try {
      await ApiService.post('services/$serviceId/enroll', {});
    } catch (e) {
      throw Exception('Error creating service: $e');
    }
  }
}
