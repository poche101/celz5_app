import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// --- AUTH & API SERVICE ---
class AuthService {
  static const String _tokenKey = 'auth_token';

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }
}

class AccessService {
  static const String _baseUrl = "https://api.example.com";

  Future<bool> verifyAndSubmit(
      {required String name, required String phone}) async {
    try {
      final response = await http
          .post(
            Uri.parse("$_baseUrl/verify-access"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "full_name": name,
              "phone_number": phone,
              "timestamp": DateTime.now().toIso8601String(),
            }),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint("API Error: $e");
      return false;
    }
  }
}

// --- MAIN NAVBAR WIDGET ---
class ScrollingBottomNavbar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const ScrollingBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<ScrollingBottomNavbar> createState() => _ScrollingBottomNavbarState();
}

class _ScrollingBottomNavbarState extends State<ScrollingBottomNavbar> {
  bool _isUserLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    bool loggedIn = await AuthService.isLoggedIn();
    if (mounted) {
      setState(() => _isUserLoggedIn = loggedIn);
    }
  }

  Future<void> _handleLiveMenu(BuildContext context, int index) async {
    final prefs = await SharedPreferences.getInstance();
    final sessionTime = prefs.getInt('live_session_timestamp') ?? 0;
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    // Check if session is less than 1 hour old (3600000 ms)
    if (currentTime - sessionTime < 3600000) {
      widget.onTap(index);
    } else {
      _showAccessModal(context, index);
    }
  }

  void _showAccessModal(BuildContext context, int index) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'AccessModal',
      barrierColor: Colors.black.withOpacity(0.7),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) =>
          _AccessModal(onSuccess: () => widget.onTap(index)),
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic list that switches between Profile (8) and Login (99)
    final List<Map<String, dynamic>> items = [
      {'name': 'Home', 'icon': LucideIcons.house, 'index': 0},
      {'name': 'About', 'icon': LucideIcons.info, 'index': 1},
      {'name': 'Events', 'icon': LucideIcons.calendar, 'index': 3},
      {'name': 'Live', 'icon': LucideIcons.monitor_play, 'index': 7},
      _isUserLoggedIn
          ? {'name': 'Profile', 'icon': LucideIcons.circle_user, 'index': 8}
          : {'name': 'Login', 'icon': LucideIcons.log_in, 'index': 99},
    ];

    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.map((item) {
            return _buildTab(
                context, item, widget.currentIndex == item['index']);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTab(
      BuildContext context, Map<String, dynamic> item, bool isActive) {
    return Expanded(
      child: InkWell(
        onTap: () {
          // 1. Handle Login Redirection
          if (item['index'] == 99) {
            Navigator.pushNamed(context, '/login_view').then((_) {
              // Refresh login status after coming back from login screen
              _checkLoginStatus();
            });
          }
          // 2. Handle Live Menu Access Control
          else if (item['index'] == 7) {
            _handleLiveMenu(context, item['index']);
          }
          // 3. Handle Standard Navigation
          else {
            widget.onTap(item['index']);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item['icon'],
              color: isActive ? Colors.orangeAccent : Colors.grey.shade400,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              item['name'],
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive ? Colors.orangeAccent : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- ACCESS MODAL ---
class _AccessModal extends StatefulWidget {
  final VoidCallback onSuccess;
  const _AccessModal({required this.onSuccess});

  @override
  State<_AccessModal> createState() => _AccessModalState();
}

class _AccessModalState extends State<_AccessModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _accessService = AccessService();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final bool success = await _accessService.verifyAndSubmit(
        name: _nameController.text,
        phone: _phoneController.text,
      );

      if (success) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(
            'live_session_timestamp', DateTime.now().millisecondsSinceEpoch);
        if (mounted) {
          Navigator.pop(context); // Close Modal
          widget.onSuccess(); // Trigger the 'Live' tab tap
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Access verification failed. Try again.")),
          );
        }
      }
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(24)),
          child: Material(
            color: Colors.transparent,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.shield_check,
                      size: 48, color: Colors.orangeAccent),
                  const SizedBox(height: 20),
                  const Text("Verify Access",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A))),
                  const SizedBox(height: 12),
                  Text("Enter your details to join the session.",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade500)),
                  const SizedBox(height: 32),
                  _buildField("Full Name", LucideIcons.user, _nameController),
                  const SizedBox(height: 16),
                  _buildField(
                      "Phone Number", LucideIcons.phone, _phoneController,
                      isPhone: true),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Text("CONTINUE",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
      String label, IconData icon, TextEditingController controller,
      {bool isPhone = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: Colors.orangeAccent),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
      validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
    );
  }
}
