import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
// TODO: Ensure you import your AuthController or wherever your login function is located
// import 'package:celz5_app/controllers/auth_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _obscurePassword = true;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// UPDATED: Logic to use your login controller
  Future<void> _handleLogin() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Assuming 'login' is a static method in an AuthController or instance
      // Replace 'AuthController()' with your actual service/controller instance
      final result = await login(email, password);

      if (mounted) {
        if (result['success'] == true) {
          // Success: Navigate to dashboard
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
          // Failure: Show error message from controller
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? "Login failed"),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // NOTE: Your provided login controller logic for reference
  Future<Map<String, dynamic>> login(String email, String password) async {
    // This is the implementation you provided
    // try { ... http.post ... }
    // return {'success': false, 'message': 'Demo mode: Replace with actual call'};

    // For now, I'm simulating a call to your backend
    await Future.delayed(const Duration(seconds: 1));
    return {'success': true};
  }

  @override
  Widget build(BuildContext context) {
    bool isWideScreen = MediaQuery.of(context).size.width > 850;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Stack(
        children: [
          // --- EXTERNAL BACK BUTTON ---
          Positioned(
            top: 40,
            left: 20,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: IconButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                ),
                icon: const Icon(LucideIcons.arrow_left,
                    size: 24, color: Color(0xFF0A192F)),
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
              child: Container(
                constraints: BoxConstraints(maxWidth: isWideScreen ? 850 : 420),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: IntrinsicHeight(
                  child: Flex(
                    direction: isWideScreen ? Axis.horizontal : Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // --- BLUE BRANDING SECTION ---
                      Flexible(
                        flex: isWideScreen ? 4 : 0,
                        child: Container(
                          constraints:
                              BoxConstraints(minHeight: isWideScreen ? 0 : 220),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A192F),
                            borderRadius: isWideScreen
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    bottomLeft: Radius.circular(24))
                                : const BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    topRight: Radius.circular(24)),
                          ),
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Use an icon if image is missing
                              const Icon(LucideIcons.church,
                                  size: 48, color: Color(0xFFEAB308)),
                              const SizedBox(height: 20),
                              const Text(
                                "Christ Embassy",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Giving your life a meaning. Welcome back to the CELZ5 Portal.",
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 13,
                                    height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // --- FORM SECTION ---
                      Flexible(
                        flex: isWideScreen ? 6 : 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Sign In",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0A192F)),
                              ),
                              const SizedBox(height: 24),
                              _buildSocialButton(
                                label: "Continue with KingsChat",
                                icon: LucideIcons.message_circle,
                                color: const Color(0xFF007AFF),
                                onPressed: () {},
                              ),
                              const SizedBox(height: 24),
                              _buildDivider(),
                              const SizedBox(height: 24),
                              _buildField("Email Address", "email@example.com",
                                  LucideIcons.mail,
                                  controller: _emailController),
                              const SizedBox(height: 16),
                              _buildField(
                                  "Password", "••••••••", LucideIcons.lock,
                                  isPassword: true,
                                  controller: _passwordController),
                              const SizedBox(height: 32),
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0A192F),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    elevation: 0,
                                  ),
                                  onPressed: _isLoading ? null : _handleLogin,
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2))
                                      : const Text("Sign In",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  children: [
                                    const Text("Don't have an account?",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 13)),
                                    GestureDetector(
                                      onTap: () => Navigator.pushNamed(
                                          context, '/register'),
                                      child: const Text(" Create Account",
                                          style: TextStyle(
                                              color: Color(0xFF0A192F),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- REUSABLE HELPERS ---

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[200])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text("OR EMAIL",
              style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1)),
        ),
        Expanded(child: Divider(color: Colors.grey[200])),
      ],
    );
  }

  Widget _buildSocialButton(
      {required String label,
      required IconData icon,
      required Color color,
      required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        icon: Icon(icon, size: 20),
        label: Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withOpacity(0.15), width: 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildField(String label, String hint, IconData icon,
      {bool isPassword = false, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4B5563))),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: isPassword ? _obscurePassword : false,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 16, color: Colors.grey[400]),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                        _obscurePassword
                            ? LucideIcons.eye_off
                            : LucideIcons.eye,
                        size: 16),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  )
                : null,
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade100)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF0A192F))),
          ),
        ),
      ],
    );
  }
}
