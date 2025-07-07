import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://mock-api.calleyacd.com/api";

  Map<String, String> get headers => {
        'Content-Type': 'application/json',
      };

  Map<String, String> authHeaders(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Future<http.Response> register(Map<String, dynamic> data) async {
    final uri = Uri.parse("$baseUrl/auth/register");
    try {
      final response = await http
          .post(uri, headers: headers, body: jsonEncode(data))
          .timeout(const Duration(seconds: 15));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> sendOtp(String email) async {
    final uri = Uri.parse("$baseUrl/auth/send-otp");
    try {
      final response = await http
          .post(uri, headers: headers, body: jsonEncode({'email': email}))
          .timeout(const Duration(seconds: 15));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> verifyOtp(Map<String, dynamic> data) async {
    final uri = Uri.parse("$baseUrl/auth/verify-otp");
    try {
      final response = await http
          .post(uri, headers: headers, body: jsonEncode(data))
          .timeout(const Duration(seconds: 15));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> getList(String userId) async {
    final uri = Uri.parse("$baseUrl/list?userId=$userId");
    try {
      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 15));
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
