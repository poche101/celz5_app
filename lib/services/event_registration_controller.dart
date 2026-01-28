import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event_registration_model.dart'; // Ensure path is correct
import 'package:celz5_app/core/constants/api_constants.dart';

class EventRegistrationController {
  Future<Map<String, dynamic>> registerEvent(
      EventRegistrationModel data) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.eventRegistration), // Using the constant here
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // 'Authorization': 'Bearer $token', // Add if your route is protected by Sanctum
        },
        body: jsonEncode(data.toJson()),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'Registration Successful',
          'data': responseData['data']
        };
      } else if (response.statusCode == 422) {
        return {
          'success': false,
          'message': 'Validation Error',
          'errors': responseData['errors']
        };
      } else {
        return {
          'success': false,
          'message': 'Server Error: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Check your internet connection.'};
    }
  }
}
