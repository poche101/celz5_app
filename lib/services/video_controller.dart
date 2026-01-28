import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
// Replace 'your_project_name' with the name in your pubspec.yaml
import 'package:celz5_app/models/video_model.dart';
import 'package:celz5_app/core/constants/api_constants.dart';

class VideoController {
  // 1. Fetch all videos (Archive)
  Future<List<VideoModel>> fetchVideos() async {
    try {
      final response =
          await http.get(Uri.parse(ApiConstants.baseUrl + "/videos"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List videosJson = data['data'];
        return videosJson.map((json) => VideoModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load videos');
      }
    } catch (e) {
      rethrow;
    }
  }

  // 2. Upload a new video and poster (Multipart)
  Future<Map<String, dynamic>> uploadVideo({
    required String title,
    required int episode,
    required String duration,
    String? description,
    required File posterFile,
    required File videoFile,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.baseUrl + "/videos"),
      );

      // Add Headers
      request.headers.addAll({
        'Accept': 'application/json',
        // 'Authorization': 'Bearer $token', // Uncomment if needed
      });

      // Add Text Fields
      request.fields['title'] = title;
      request.fields['episode'] = episode.toString();
      request.fields['duration'] = duration;
      if (description != null) request.fields['description'] = description;

      // Add Poster Image
      request.files.add(await http.MultipartFile.fromPath(
        'poster',
        posterFile.path,
      ));

      // Add Video File
      request.files.add(await http.MultipartFile.fromPath(
        'video',
        videoFile.path,
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {'success': true, 'message': responseData['message']};
      } else {
        return {
          'success': false,
          'message': responseData['errors'] ?? 'Upload failed'
        };
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // 3. Delete Video
  Future<bool> deleteVideo(int id) async {
    final response = await http.delete(
      Uri.parse("${ApiConstants.baseUrl}/videos/$id"),
      headers: {'Accept': 'application/json'},
    );
    return response.statusCode == 200;
  }
}
