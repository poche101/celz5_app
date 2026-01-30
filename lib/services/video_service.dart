import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:celz5_app/models/video_model.dart';

class VideoService {
  static const String _baseUrl = "https://api.example.com/videos";

  Future<List<VideoModel>> fetchVideos({int page = 1, int limit = 10}) async {
    try {
      // 1. FIXED: Implemented actual network call with query parameters
      final response = await http.get(
        Uri.parse("$_baseUrl?page=$page&limit=$limit"),
        headers: {"Content-Type": "application/json"},
      ).timeout(const Duration(seconds: 10)); // Added timeout for better UX

      // 2. FIXED: Checking for HTTP status codes (not just try/catch)
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // 3. FIXED: Mapping real API response instead of returning mock data
        return data.map((json) => VideoModel.fromJson(json)).toList();
      } else {
        // Handle specific server errors (404, 500, etc)
        throw Exception("Server Error: ${response.statusCode}");
      }
    } on http.ClientException {
      throw Exception("Check your internet connection");
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }
}
