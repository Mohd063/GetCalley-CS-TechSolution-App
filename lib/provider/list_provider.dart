import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListProvider with ChangeNotifier {
  bool _isLoading = false;
  List<dynamic> _callList = [];

  bool get isLoading => _isLoading;
  List<dynamic> get callList => _callList;

  Future<void> fetchCallList(String userId) async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('https://mock-api.calleyacd.com/api/list/$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data["calls"] != null && data["calls"] is List) {
          _callList = data["calls"];
        } else {
          _callList = [];
        }
      } else {
        _callList = [];
      }
    } catch (e) {
      _callList = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void resetList() {
    _callList = [];
    notifyListeners();
  }
}
