import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../services/auth_controller.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool _obscurePassword = true;
  bool _isLoading = false;
  String _password = "";

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  double _calculateStrength(String value) {
    if (value.isEmpty) return 0;
    if (value.length < 6) return 0.3;
    if (value.length < 10) return 0.6;
    return 1.0;
  }

  Color _getStrengthColor(double strength) {
    if (strength <= 0.3) return Colors.redAccent;
    if (strength <= 0.6) return Colors.orangeAccent;
    return Colors.greenAccent;
  }

  void _handleRegister() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please fill in all fields"),
            behavior: SnackBarBehavior.floating),
      );
      return;
    }

    setState(() => _isLoading = true);
    final auth = AuthController();
    final result = await auth.register(
      _nameController.text,
      _emailController.text,
      "",
      _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result['success']) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double strength = _calculateStrength(_password);
    bool isWideScreen = MediaQuery.of(context).size.width > 850;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Stack(
        children: [
          // --- PAGE LEVEL BACK BUTTON ---
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              /// UPDATED: Navigates to the '/home' route and clears the stack
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              ),
              icon: const Icon(LucideIcons.arrow_left,
                  size: 24, color: Color(0xFF0A192F)),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    constraints:
                        BoxConstraints(maxWidth: isWideScreen ? 850 : 420),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 24,
                            offset: const Offset(0, 12)),
                      ],
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // --- LEFT SIDE: MINISTRY BRANDING ---
                          if (isWideScreen)
                            Expanded(
                              flex: 4,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0A192F),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    bottomLeft: Radius.circular(24),
                                  ),
                                ),
                                padding: const EdgeInsets.all(40),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        'assets/images/logo.png',
                                        height: 60,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(LucideIcons.tv,
                                              size: 48,
                                              color: Color(0xFFEAB308));
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    const Text(
                                      "Christ Embassy",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "Giving your life a meaning. Join our global vision of taking the divine presence of God to the peoples and nations of the world.",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 14,
                                        height: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Container(
                                      height: 2,
                                      width: 40,
                                      color: const Color(0xFFEAB308),
                                    )
                                  ],
                                ),
                              ),
                            ),

                          // --- RIGHT SIDE: COMPACT FORM ---
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 40),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Create Account",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF0A192F)),
                                  ),
                                  const SizedBox(height: 24),
                                  _buildField("Full Name", "Enter your name",
                                      LucideIcons.user,
                                      controller: _nameController),
                                  const SizedBox(height: 16),
                                  _buildField("Email Address",
                                      "email@example.com", LucideIcons.mail,
                                      controller: _emailController),
                                  const SizedBox(height: 16),
                                  _buildField(
                                    "Password",
                                    "••••••••",
                                    LucideIcons.lock,
                                    isPassword: true,
                                    controller: _passwordController,
                                    onChanged: (val) =>
                                        setState(() => _password = val),
                                  ),
                                  if (_password.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    LinearProgressIndicator(
                                      value: strength,
                                      backgroundColor: Colors.grey[100],
                                      color: _getStrengthColor(strength),
                                      minHeight: 3,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ],
                                  const SizedBox(height: 32),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF0A192F),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        elevation: 0,
                                      ),
                                      onPressed:
                                          _isLoading ? null : _handleRegister,
                                      child: _isLoading
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2))
                                          : const Text("Register",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
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
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already registered?",
                          style: TextStyle(color: Colors.grey, fontSize: 13)),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Sign In",
                            style: TextStyle(
                                color: Color(0xFF0A192F),
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, String hint, IconData icon,
      {bool isPassword = false,
      TextEditingController? controller,
      Function(String)? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4B5563))),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: isPassword ? _obscurePassword : false,
          onChanged: onChanged,
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
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
