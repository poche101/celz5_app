import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CelzBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CelzBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  /// Logic: Checks session validity (1-hour window)
  Future<void> _handleLiveMenu(BuildContext context, int index) async {
    final prefs = await SharedPreferences.getInstance();
    final sessionTime = prefs.getInt('live_session_timestamp') ?? 0;
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    // 1 hour = 3,600,000 milliseconds
    if (currentTime - sessionTime < 3600000) {
      onTap(index); // Access granted directly
    } else {
      _showAccessModal(context, index); // Show verification modal
    }
  }

  /// UI: Elegant Scale-in Modal
  void _showAccessModal(BuildContext context, int index) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'AccessModal',
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => const SizedBox(),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: _AccessModal(onSuccess: () => onTap(index)),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {'name': 'Home', 'icon': LucideIcons.house, 'index': 0},
      {'name': 'About', 'icon': LucideIcons.info, 'index': 1},
      {'name': 'Events', 'icon': LucideIcons.calendar, 'index': 3},
      {'name': 'Live', 'icon': LucideIcons.monitor_play, 'index': 7},
      {'name': 'Profile', 'icon': LucideIcons.circle_user, 'index': 8},
    ];

    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.map((item) {
            bool isActive = currentIndex == item['index'];
            return _buildTab(context, item, isActive);
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
          if (item['index'] == 7) {
            _handleLiveMenu(context, item['index']);
          } else {
            onTap(item['index']);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.orangeAccent.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                item['icon'],
                color: isActive ? Colors.orangeAccent : Colors.grey.shade600,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item['name'],
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? Colors.orangeAccent : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Internal Verification Modal ---

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

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      // Save current timestamp for the 1-hour session
      await prefs.setInt(
          'live_session_timestamp', DateTime.now().millisecondsSinceEpoch);

      if (mounted) {
        Navigator.pop(context); // Close Modal
        widget.onSuccess(); // Grant access
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 28),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 40,
              spreadRadius: -10,
            )
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.shield_check,
                      size: 32, color: Colors.orangeAccent),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Verification",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Enter your details to access the live stream session.",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: Colors.grey, fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 28),
                _buildField("Full Name", LucideIcons.user, _nameController),
                const SizedBox(height: 16),
                _buildField("Phone Number", LucideIcons.phone, _phoneController,
                    isPhone: true),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                    ),
                    child: const Text(
                      "Gain Access",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
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
      style: const TextStyle(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        prefixIcon: Icon(icon, size: 20, color: Colors.orangeAccent),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.orangeAccent, width: 2),
        ),
      ),
      validator: (v) => v!.isEmpty ? "This field is required" : null,
    );
  }
}
