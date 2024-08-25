import 'package:client/babysitting-services/model.dart';
import 'package:client/common/api_service.dart';

class BabySittingService {
  static Future<List<BabySittingServiceData>> getBabySittingServiceList() async {
    try {
      final response = await ApiService.get('services');

      if (response is List) {
        final List<BabySittingServiceData> services =
            response.map((json) => BabySittingServiceData.fromJson(json)).toList();
        return services;
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      print('Error fetching services list: $e');
      rethrow;
    }
  }
}
