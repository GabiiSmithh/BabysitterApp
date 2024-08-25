import 'package:client/babysitting-services/model.dart';
import 'package:client/common/api_service.dart';

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
    try {
      final payload = {
        "tutor_id": serviceData['tutor_id'],
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
}
