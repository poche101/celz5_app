import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

// 1. API Service Layer
class ContactService {
  static Future<bool> sendMessage({
    required String name,
    required String email,
    required String message,
  }) async {
    try {
      // Replace with your actual endpoint: http.post(Uri.parse('...'), body: {...})
      await Future.delayed(const Duration(seconds: 2));

      // Simulate a successful response
      return true;
    } catch (e) {
      debugPrint("API Error: $e");
      return false;
    }
  }
}

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  // 2. Form Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  // 3. Memory Management: Always dispose controllers
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // 4. Submission Logic
  Future<void> _handleSubmission() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final success = await ContactService.sendMessage(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      message: _messageController.text.trim(),
    );

    setState(() => _isSubmitting = false);

    if (mounted) {
      if (success) {
        _formKey.currentState!.reset();
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
        _showStatusSnackBar(
            "Message sent! We'll get back to you soon.", Colors.green);
      } else {
        _showStatusSnackBar(
            "Failed to send message. Please try again.", Colors.redAccent);
      }
    }
  }

  void _showStatusSnackBar(String message, Color bgColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF9FAFB),
      child: Column(
        children: [
          _buildHeaderSection(),
          Transform.translate(
            offset: const Offset(0, -60),
            child: _buildContactFormCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 80, 24, 120),
      decoration: const BoxDecoration(
        color: Color(0xFF0A192F),
        image: DecorationImage(
          image: NetworkImage(
              'https://images.unsplash.com/photo-1516738901171-8eb4fc13bd20?q=80&w=2070'),
          fit: BoxFit.cover,
          opacity: 0.1,
        ),
      ),
      child: Column(
        children: [
          const Text(
            "GET IN TOUCH",
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            "Reach out for prayers or inquiries. Our team is here to support you.",
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: 16, color: Color(0xFF94A3B8), height: 1.5),
          ),
          const SizedBox(height: 24),
          Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(2))),
        ],
      ),
    );
  }

  Widget _buildContactFormCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 30,
              offset: const Offset(0, 15))
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Send a Message",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 24),
            _buildField(
              controller: _nameController,
              label: "Full Name",
              icon: LucideIcons.user,
              hint: "Enter your name",
              validator: (v) => v!.isEmpty ? "Please enter your name" : null,
            ),
            const SizedBox(height: 20),
            _buildField(
              controller: _emailController,
              label: "Email Address",
              icon: LucideIcons.mail,
              hint: "example@email.com",
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v!.isEmpty) return "Email is required";
                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(v))
                  return "Enter a valid email";
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildField(
              controller: _messageController,
              label: "Message",
              icon: LucideIcons.message_square,
              hint: "How can we help you?",
              maxLines: 4,
              validator: (v) => v!.length < 10 ? "Message is too short" : null,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _handleSubmission,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.orangeAccent.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Text("SEND MESSAGE",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            letterSpacing: 1.1)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    required String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: Color(0xFF64748B),
                letterSpacing: 1.2)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(fontSize: 16, color: Color(0xFF1E293B)),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: Colors.orangeAccent),
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 15),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.all(16),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Colors.orangeAccent, width: 1.5)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.redAccent)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Colors.redAccent, width: 1.5)),
          ),
        ),
      ],
    );
  }
}
