import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:celz5_app/models/testimony_model.dart';
import 'package:celz5_app/core/constants/api_constants.dart'; // Ensure this path is correct

class TestimonyService {
  final String? authToken;

  TestimonyService({this.authToken});

  // 1. Fetch Feed (Publicly available)
  Future<List<TestimonyModel>> fetchTestimonies() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.testimonies),
        headers: {
          'Accept': 'application/json',
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        // Laravel API Resources wrap data in a 'data' key
        List data = decoded['data'] ?? [];
        return data.map((item) => TestimonyModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load testimonies');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  // 2. Post Testimony (Using Named Parameters & ApiConstants)
  Future<Map<String, dynamic>> submitTestimony({
    required String name,
    required String group,
    required String content,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.testimonies),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'full_name': name,
          'church_group': group,
          'content': content,
        }),
      );

      final result = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'status': 'success',
          'message': result['message'] ?? 'Posted successfully'
        };
      } else if (response.statusCode == 403) {
        // This maps to your Laravel Profile Middleware
        return {
          'status': 'profile_incomplete',
          'message': result['message'] ?? 'Please complete your profile first.'
        };
      } else {
        return {
          'status': 'error',
          'message': result['message'] ?? 'Failed to submit testimony'
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Connection error: Could not reach server.'
      };
    }
  }
}
