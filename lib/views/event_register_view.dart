import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class EventRegisterView extends StatefulWidget {
  const EventRegisterView({super.key});

  @override
  State<EventRegisterView> createState() => _EventRegisterViewState();
}

class _EventRegisterViewState extends State<EventRegisterView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Elegant Banner with Back Navigation ---
            _buildBanner(context),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Title with Two-Part Underline ---
                    const TwoPartUnderlineTitle(text: "Event Submission"),
                    const SizedBox(height: 8),
                    Text(
                      "Provide your church details to register for this event.",
                      style:
                          TextStyle(color: Colors.blueGrey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 32),

                    // --- Form Fields ---
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: _buildTextField(
                                "Title", LucideIcons.user_check, "Deacon")),
                        const SizedBox(width: 12),
                        Expanded(
                            flex: 5,
                            child: _buildTextField(
                                "Full Name", LucideIcons.user, "John Doe")),
                      ],
                    ),
                    _buildTextField(
                        "Phone Number", LucideIcons.phone, "+234 ..."),
                    _buildTextField(
                        "Email Address", LucideIcons.mail, "user@celz5.org"),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(color: Color(0xFFE2E8F0), thickness: 1),
                    ),

                    _buildTextField(
                        "Group", LucideIcons.users, "Lighthouse Group"),
                    _buildTextField("Church", LucideIcons.map_pin, "Church"),
                    _buildTextField(
                        "Cell Name", LucideIcons.layers, "Grace Cell"),

                    const SizedBox(height: 40),

                    // --- Submit Button ---
                    _buildSubmitButton(),
                    const SizedBox(height: 50),
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
      height: 240,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A192F), Color(0xFF0D47A1), Color(0xFF0A192F)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Stack(
        children: [
          // Background Icon Decoration - FIXED NAME HERE
          Positioned(
            right: -20,
            top: 20,
            child: Icon(LucideIcons.signature, // Changed from file_signature
                size: 180,
                color: Colors.white.withOpacity(0.05)),
          ),

          // Back Arrow Navigation
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pushReplacementNamed(context, '/events'),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(LucideIcons.arrow_left,
                    color: Colors.white, size: 22),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.calendar_range,
                      color: Colors.orangeAccent, size: 44),
                  const SizedBox(height: 12),
                  const Text(
                    "CONFERENCE 2026",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "REGISTRATION PORTAL",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 8),
          TextFormField(
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
              prefixIcon: Icon(icon, size: 19, color: const Color(0xFF0D47A1)),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 18),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide:
                    const BorderSide(color: Color(0xFF0D47A1), width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 62,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D47A1).withOpacity(0.25),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Submission Successful")),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A192F),
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 0,
        ),
        child: const Text(
          "Submit Registration",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

// --- Custom Painter for the Two-Part Orange Underline ---
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
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0A192F),
          ),
        ),
        const SizedBox(height: 6),
        CustomPaint(
          size: const Size(80, 5),
          painter: UnderlinePainter(),
        ),
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
      ..strokeWidth = 5;

    // Part 1: Main line (70% of length)
    canvas.drawLine(Offset.zero, Offset(size.width * 0.7, 0), paint);

    // Part 2: Accent dot/short line (starts at 85%)
    canvas.drawLine(Offset(size.width * 0.85, 0), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
