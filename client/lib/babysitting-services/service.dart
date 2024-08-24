import 'package:client/babysitting-services/model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServiceData {
  final String id;
  final String? babysitterId;
  final String tutorId;
  final DateTime startDate;
  final DateTime endDate;
  final int value;
  final int childrenCount;
  final String address;

  const ServiceData({
    required this.id,
    required this.babysitterId,
    required this.tutorId,
    required this.startDate,
    required this.endDate,
    required this.value,
    required this.childrenCount,
    required this.address,
  });
}

class BabySittingService {
  static Future<List<BabysittingService>> getBabySittingServiceList() async {
    try {
      final url = Uri.parse('http://201.23.18.202:3333/services');
      final response = await http.get(url);

      final List<dynamic> data = json.decode(response.body);

      final List<BabysittingService> requests = data.map((json) => BabysittingService.fromJson(json)).toList();

      return requests;
    } catch (e) {
      print('Error fetching services list: $e');
      rethrow;
    }
  }
}
