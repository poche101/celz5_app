import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScrollingBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const ScrollingBottomNavbar({
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
      onTap(index); // Access granted
    } else {
      _showAccessModal(context, index); // Show verification modal
    }
  }

  /// UI: Scale-in Modal Transition
  void _showAccessModal(BuildContext context, int index) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'AccessModal',
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) =>
          _AccessModal(onSuccess: () => onTap(index)),
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
            blurRadius: 10,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.map((item) {
            return _buildTab(context, item, currentIndex == item['index']);
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
            Icon(
              item['icon'],
              color: isActive ? Colors.orangeAccent : Colors.grey.shade600,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              item['name'],
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? Colors.orangeAccent : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- The Verification Modal ---

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

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
          'live_session_timestamp', DateTime.now().millisecondsSinceEpoch);

      if (mounted) {
        Navigator.pop(context);
        widget.onSuccess();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Material(
            color: Colors.transparent,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.shield_check,
                      size: 48, color: Colors.orangeAccent),
                  const SizedBox(height: 16),
                  const Text("Verify Access",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  _buildField("Full Name", LucideIcons.user, _nameController),
                  const SizedBox(height: 12),
                  _buildField(
                      "Phone Number", LucideIcons.phone, _phoneController,
                      isPhone: true),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Continue",
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
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (v) => v!.isEmpty ? "Required" : null,
    );
  }
}
