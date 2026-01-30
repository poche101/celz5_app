import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

// --- 1. DATA MODEL (Fixed 'EventRegistration' error) ---
class EventRegistration {
  final String title;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String group;
  final String church;
  final String cellName;

  EventRegistration({
    required this.title,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.group,
    required this.church,
    required this.cellName,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'email': email,
        'group': group,
        'church': church,
        'cellName': cellName,
      };
}

// --- 2. MAIN VIEW ---
class EventRegisterView extends StatefulWidget {
  const EventRegisterView({super.key});

  @override
  State<EventRegisterView> createState() => _EventRegisterViewState();
}

class _EventRegisterViewState extends State<EventRegisterView> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _groupController = TextEditingController();
  final TextEditingController _churchController = TextEditingController();
  final TextEditingController _cellController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _groupController.dispose();
    _churchController.dispose();
    _cellController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmission() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      // Fixed 'registrationData' unused error
      final registrationData = EventRegistration(
        title: _titleController.text,
        fullName: _nameController.text,
        phoneNumber: _phoneController.text,
        email: _emailController.text,
        group: _groupController.text,
        church: _churchController.text,
        cellName: _cellController.text,
      );

      // This is where you send data to your API
      debugPrint("Sending to API: ${registrationData.toJson()}");

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration Successful!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBanner(context),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TwoPartUnderlineTitle(text: "Event Submission"),
                    const SizedBox(height: 12),
                    const Text(
                      "Provide your church details to register for this event.",
                      style: TextStyle(
                          fontSize: 16, color: Colors.blueGrey, height: 1.5),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: _buildTextField(
                                "Title",
                                LucideIcons.user_check,
                                "Deacon",
                                _titleController)),
                        const SizedBox(width: 12),
                        Expanded(
                            flex: 6,
                            child: _buildTextField("Full Name",
                                LucideIcons.user, "John Doe", _nameController)),
                      ],
                    ),
                    _buildTextField("Phone Number", LucideIcons.phone,
                        "+234 ...", _phoneController),
                    _buildTextField("Email Address", LucideIcons.mail,
                        "user@example.org", _emailController),
                    const Divider(height: 48),
                    _buildTextField("Group", LucideIcons.users,
                        "Lighthouse Group", _groupController),
                    _buildTextField("Church", LucideIcons.map_pin, "Church",
                        _churchController),
                    _buildTextField("Cell Name", LucideIcons.layers,
                        "Grace Cell", _cellController),
                    const SizedBox(height: 40),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF0D47A1),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(LucideIcons.calendar_range,
                color: Colors.orangeAccent, size: 50),
            SizedBox(height: 16),
            Text("CONFERENCE 2026",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900)),
            Text("REGISTRATION PORTAL",
                style: TextStyle(
                    color: Colors.white70, fontSize: 14, letterSpacing: 3)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, String hint,
      TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            validator: (v) => v!.isEmpty ? "Field required" : null,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, size: 20),
              filled: true,
              fillColor: Colors.white,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _handleSubmission,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A192F),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: _isSubmitting
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Submit Registration",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// --- 3. CUSTOM UI COMPONENTS (Fixed 'TwoPartUnderlineTitle' error) ---
class TwoPartUnderlineTitle extends StatelessWidget {
  final String text;
  const TwoPartUnderlineTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0A192F)),
        ),
        const SizedBox(height: 8),
        CustomPaint(size: const Size(100, 6), painter: UnderlinePainter()),
      ],
    );
  }
}

class UnderlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orangeAccent
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;
    canvas.drawLine(Offset.zero, Offset(size.width * 0.7, 0), paint);
    canvas.drawLine(Offset(size.width * 0.85, 0), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
