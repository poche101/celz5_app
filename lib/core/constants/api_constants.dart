class ApiConstants {
  // Base URL - Updated for Android Simulator / Local Network Development
  // Using your specific machine IP to allow connection from the emulator/device
  static const String baseUrl = "http://192.168.43.37:8000/api";

  // Base URL for Media (needed to show posters and play videos)
  // Used for prefixing t.thumbnailUrl if the API returns relative paths
  static const String storageBaseUrl = "http://192.168.43.37:8000/storage/";

  // Auth Endpoints
  static const String register = "$baseUrl/register";
  static const String login = "$baseUrl/login";
  static const String forgotPassword = "$baseUrl/forgot-password";

  // Profile Endpoints
  static const String updateProfile = "$baseUrl/profile/update";
  static const String getProfile = "$baseUrl/profile/me";

  // Event Registration
  static const String eventRegistration = "$baseUrl/event-registration/store";

  // Testimony Endpoints
  // GET: fetch all testimonies, POST: share a new testimony
  static const String testimonies = "$baseUrl/testimonies";

  // Video Archive Endpoints
  static const String videos = "$baseUrl/videos";
  static const String deleteVideo = "$baseUrl/videos"; // Append /ID for DELETE
}
