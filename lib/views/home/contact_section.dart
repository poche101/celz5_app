import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:url_launcher/url_launcher.dart'; // Import for launching links

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();

  // Configuration for Social Links - Input your links here
  final Map<String, String> socialLinks = {
    'kingschat': 'https://kingsch.at/user/celz5',
    'instagram': 'https://instagram.com/celz5',
    'twitter': 'https://twitter.com/celz5',
    'facebook': 'https://facebook.com/celz5',
    'tiktok': 'https://tiktok.com/@celz5',
    'youtube': 'https://youtube.com/c/celz5',
  };

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          _buildMainContent(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          "Get In Touch",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0A192F),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 6),
            Container(
                height: 4,
                width: 12,
                decoration: BoxDecoration(
                    color: Colors.orangeAccent.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2))),
          ],
        ),
      ],
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoBar(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildForm(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF0A192F),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              _infoTile(LucideIcons.phone, "+234 907 641 5312"),
              _infoTile(LucideIcons.mail, "contact@celz5.org"),
              _infoTile(LucideIcons.map_pin, "Loveworld Arena Lekki, Lagos"),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(color: Colors.white12),
          ),
          // Social Icons Grid
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            children: [
              _socialIcon(LucideIcons.message_circle, "KingsChat",
                  socialLinks['kingschat']!),
              _socialIcon(
                  LucideIcons.youtube, "YouTube", socialLinks['youtube']!),
              _socialIcon(
                  LucideIcons.music,
                  "TikTok",
                  socialLinks[
                      'tiktok']!), // Lucide representative icon for TikTok
              _socialIcon(LucideIcons.instagram, "Instagram",
                  socialLinks['instagram']!),
              _socialIcon(
                  LucideIcons.twitter, "Twitter", socialLinks['twitter']!),
              _socialIcon(
                  LucideIcons.facebook, "Facebook", socialLinks['facebook']!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
              label: "Full Name", icon: LucideIcons.user, hint: "John Doe"),
          const SizedBox(height: 20),
          _buildTextField(
              label: "Email Address",
              icon: LucideIcons.mail,
              hint: "john@example.com"),
          const SizedBox(height: 20),
          _buildTextField(
              label: "Message",
              icon: LucideIcons.message_square,
              hint: "How can we help you?",
              maxLines: 4),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Handle form submission
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text("Send Message",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      {required String label,
      required IconData icon,
      required String hint,
      int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: Color(0xFF0A192F))),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18, color: Colors.orangeAccent),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Colors.orangeAccent, width: 1.5)),
          ),
        ),
      ],
    );
  }

  Widget _infoTile(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.orangeAccent, size: 16),
        const SizedBox(width: 8),
        Text(text,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _socialIcon(IconData icon, String tooltip, String url) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () => _launchURL(url),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
