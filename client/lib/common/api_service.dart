import 'dart:convert';
import 'package:client/common/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static late String _baseUrl;
  static final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
  };
  static List<String> _roles = [];

  static void initialize(String baseUrl) {
    _baseUrl = baseUrl;
  }

  static Future<void> setAuthorizationTokenAndRoles(
      String token, List<String> roles) async {
    _defaultHeaders['Authorization'] = 'Bearer $token';
    _roles = roles;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('roles', roles);

    String profileType = roles[0];
    AuthService.setCurrentProfileType(profileType);
  }

  static Future<List<String>> getRoles() async {
    if (_roles.isEmpty) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _roles = prefs.getStringList('roles') ?? [];
    }
    return _roles;
  }

  static Future<dynamic> get(String path,
      {Map<String, String>? headers}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$path'),
      headers: {..._defaultHeaders, ...?headers},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to perform GET request');
    }
  }

  static Future<Map<String, dynamic>> post(
      String path, Map<String, dynamic> payload,
      {Map<String, String>? headers}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$path'),
      headers: {..._defaultHeaders, ...?headers},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to perform POST request');
    }
  }

  static Future<Map<String, dynamic>> put(
      String path, Map<String, dynamic> payload,
      {Map<String, String>? headers}) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$path'),
      headers: {..._defaultHeaders, ...?headers},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to perform PUT request');
    }
  }

  static Future<Map<String, dynamic>> patch(
      String path, Map<String, dynamic> payload,
      {Map<String, String>? headers}) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/$path'),
      headers: {..._defaultHeaders, ...?headers},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to perform patch request');
    }
  }

  static Future<void> delete(String path,
      {Map<String, String>? headers}) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$path'),
      headers: {..._defaultHeaders, ...?headers},
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to perform DELETE request');
    }
  }
}
