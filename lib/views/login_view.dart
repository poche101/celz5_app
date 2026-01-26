import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
// Updated to your specific path
import 'package:celz5_app/views/shared/church_sidebar.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Use -1 so no menu item looks "selected" while on the login screen
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Your custom sidebar from lib/views/shared/church_sidebar.dart
          ChurchSidebar(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
              setState(() => _selectedIndex = index);
              // Optional: Logic to allow browsing "About" or "Events" before login
            },
          ),

          // Main Login Form
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Welcome to the CELZ5 Portal.",
                        style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      ),
                      const SizedBox(height: 40),

                      // KingsChat Social Login
                      _buildSocialButton(
                        label: "Continue with KingsChat",
                        icon: LucideIcons.message_circle,
                        color: const Color(0xFF007AFF),
                        onPressed: () {
                          // TODO: KingsChat Auth Logic
                        },
                      ),

                      const SizedBox(height: 24),

                      // "OR" Divider
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[200])),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "OR EMAIL",
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey[200])),
                        ],
                      ),

                      const SizedBox(height: 24),

                      _buildField(
                          "Email Address", "you@example.com", LucideIcons.mail),
                      const SizedBox(height: 20),
                      _buildField("Password", "••••••••", LucideIcons.lock,
                          isPassword: true),

                      const SizedBox(height: 32),

                      // Sign In Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A192F),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/dashboard');
                          },
                          child: const Text("Sign In",
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Registration Link
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?",
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 14)),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/register'),
                              child: const Text(
                                "Create one here",
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
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

  // --- REUSABLE WIDGETS ---

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
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildField(String label, String hint, IconData icon,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF374151))),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 18, color: Colors.grey[400]),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color(0xFF0A192F), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
