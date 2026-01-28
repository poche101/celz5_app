import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../core/constants/api_constants.dart'; // Import your constants

class AuthController {
  // --- REGISTER ---
  Future<Map<String, dynamic>> register(
      String name, String email, String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.register), // Used constant
        headers: {'Accept': 'application/json'},
        body: {
          'full_name': name,
          'email': email,
          'phone': phone,
          'password': password,
        },
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': _getErrorMessage(e)};
    }
  }

  // --- LOGIN ---
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.login), // Used constant
        headers: {'Accept': 'application/json'},
        body: {
          'email': email,
          'password': password,
        },
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': _getErrorMessage(e)};
    }
  }

  // --- UPDATE PROFILE ---
  Future<Map<String, dynamic>> updateProfile(
      UserModel user, String token) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.updateProfile), // Used constant
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(user.toJson()),
      );
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': _getErrorMessage(e)};
    }
  }

  // Helper to process responses
  Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': data};
      } else {
        String errorMsg = data['message'] ?? 'An error occurred';
        if (data['errors'] != null) {
          errorMsg = data['errors'].toString();
        }
        return {'success': false, 'message': errorMsg};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Format error: Invalid server response'
      };
    }
  }

  // Helper to catch network errors
  String _getErrorMessage(dynamic e) {
    if (e is SocketException) return "No Internet connection.";
    if (e is HttpException) return "Couldn't find the service.";
    if (e is FormatException) return "Bad response format.";
    return "Something went wrong: $e";
  }
}
