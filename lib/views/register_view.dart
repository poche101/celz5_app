import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
// Ensure this path matches your file structure
import 'package:celz5_app/views/shared/church_sidebar.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  // Neutral index for the registration process
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // --- SHARED SIDEBAR ---
          ChurchSidebar(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
              setState(() => _selectedIndex = index);
              // Handle navigation logic here (e.g., navigating to Home or About)
            },
          ),

          // --- REGISTRATION FORM ---
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
                        "Create Account",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Join the CELZ5 community today.",
                        style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      ),
                      const SizedBox(height: 40),

                      // INPUT FIELDS
                      _buildField("Full Name", "John Doe", LucideIcons.user),
                      const SizedBox(height: 20),
                      _buildField("Email Address", "john@example.com",
                          LucideIcons.mail),
                      const SizedBox(height: 20),
                      _buildField("Phone Number", "+234...", LucideIcons.phone),
                      const SizedBox(height: 20),
                      _buildField("Password", "Create a strong password",
                          LucideIcons.lock,
                          isPassword: true),

                      const SizedBox(height: 32),

                      // REGISTER BUTTON
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
                            // Logic for account creation
                            Navigator.pushReplacementNamed(
                                context, '/dashboard');
                          },
                          child: const Text("Create Account",
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // BACK TO LOGIN
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account?",
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 14)),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w700,
                                ),
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

  // --- REUSABLE INPUT FIELD ---
  Widget _buildField(String label, String hint, IconData icon,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF374151)),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon: Icon(icon, size: 18, color: Colors.grey[400]),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
