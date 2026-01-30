import 'dart:convert';
import 'package:http/http.dart' as http;

class AccessService {
  static const String _baseUrl =
      "https://api.example.com"; // Replace with your URL

  Future<bool> verifyAndSubmit(
      {required String name, required String phone}) async {
    try {
      final response = await http
          .post(
            Uri.parse("$_baseUrl/verify-access"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "full_name": name,
              "phone_number": phone,
            }),
          )
          .timeout(const Duration(seconds: 10));

      // Return true if the server confirms access (e.g., status 200 or 201)
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false; // Handle network errors
    }
  }
}
