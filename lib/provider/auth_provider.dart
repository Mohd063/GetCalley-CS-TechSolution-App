import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_calley/model/user_model.dart';
import 'package:get_calley/services/api_servies.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  UserModel? _user;

  String? get userName => _user?.name;
  String? get userMobile => _user?.mobile;
  UserModel? get user => _user;

  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    required String mobile,
  }) async {
    try {
      Response res = await _api.register({
        'name': name,
        'email': email,
        'password': password,
        'mobile': mobile,
      });

      if (res.statusCode == 200 || res.statusCode == 201) {
        return {'success': true, 'message': 'Registration successful'};
      } else {
        var body = jsonDecode(res.body);
        return {
          'success': false,
          'message': body['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Something went wrong: $e',
      };
    }
  }

  Future<bool> sendOtp(String email) async {
    try {
      Response res = await _api.sendOtp(email);
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }Future<String?> verifyOtp(Map<String, dynamic> data) async {
  try {
    Response res = await _api.verifyOtp(data);
    var json = jsonDecode(res.body);

    if (res.statusCode == 200) {
      // Only save email, no full user object
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('email', data['email']);

      notifyListeners();
      return null; // success
    } else {
      return json['message'] ?? "OTP verification failed";
    }
  } catch (e) {
    return "Something went wrong. Please try again.";
  }
}


  Future<void> saveUserToPrefs(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('id', user.id);
    prefs.setString('name', user.name);
    prefs.setString('email', user.email);
    prefs.setString('mobile', user.mobile);
  }

  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('id');
    final name = prefs.getString('name');
    final email = prefs.getString('email');
    final mobile = prefs.getString('mobile');

    if (email != null && email.isNotEmpty) {
      _user = UserModel(
        email: email,
        id: id ?? '',
        mobile: mobile ?? '',
        name: name ?? '',
      );
      notifyListeners();
    }
  }
}
