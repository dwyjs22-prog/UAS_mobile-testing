import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api.dart';

class ApiService {
  // =======================
  // 🔐 LOGIN
  // =======================
  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${Api.baseUrl}/login'),
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'email': email,
          'password': password,
        },
      );

      final result = json.decode(response.body);

      return response.statusCode == 200 && result['status'] == true;
    } catch (e) {
      return false;
    }
  }

  // =======================
  // 📝 REGISTER
  // =======================
  static Future<bool> register(
    String nama,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${Api.baseUrl}/register'),
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'nama': nama,
          'email': email,
          'password': password,
        },
      );

      final result = json.decode(response.body);

      return response.statusCode == 200 && result['status'] == true;
    } catch (e) {
      return false;
    }
  }
}
