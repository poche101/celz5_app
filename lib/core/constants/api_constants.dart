class ApiConstants {
  // Base URL - Change this to your actual server IP or domain
  // Use http://10.0.2.2:8000/api if testing on an Android Emulator with local Laravel
  static const String baseUrl = "https://your-api-domain.com/api";

  // Auth Endpoints
  static const String register = "$baseUrl/register";
  static const String login = "$baseUrl/login";
  static const String forgotPassword = "$baseUrl/forgot-password";

  // Profile Endpoints
  static const String updateProfile = "$baseUrl/profile/update";
  static const String getProfile = "$baseUrl/profile/me";

  // Event Registration (Matches your new Laravel Controller)
  static const String eventRegistration = "$baseUrl/event-registration/store";
}
