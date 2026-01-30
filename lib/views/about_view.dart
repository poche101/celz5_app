import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  final Color primaryDark = const Color(0xFF0A192F);
  final Color primaryBlue = const Color(0xFF0D47A1);
  final Color accentOrange = Colors.orangeAccent;

  final String pastorChrisImageUrl = "/assets/images/p-chris.webp";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Column(
                children: [
                  _buildResponsiveIntro(context),
                  const SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader("Our Core Vision"),
                        const SizedBox(height: 24),
                        _buildFeatureCard(
                          icon: LucideIcons.eye,
                          title: "Our Vision",
                          description:
                              "Christ Embassy is not just a local assembly; it’s a vision. To take His divine presence to the nations of the world.",
                        ),
                        _buildFeatureCard(
                          icon: LucideIcons.church,
                          title: "More Than A Church",
                          description:
                              "You become part of something that’s more than a church; you become part of a great vision, God’s vision.",
                        ),
                        _buildFeatureCard(
                          icon: LucideIcons.sparkles,
                          title: "Giving Your Life Meaning",
                          description:
                              "One Word from God will revolutionize your life forever. More blessings will be established in your life.",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260, // Slightly taller to accommodate the two-part underline
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryDark, primaryBlue, primaryDark],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: -10,
            child: Icon(LucideIcons.landmark,
                size: 200, color: Colors.white.withOpacity(0.04)),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(LucideIcons.arrow_left,
                        color: Colors.white, size: 24),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "About Us",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // --- TWO PART UNDERLINE ---
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 5,
                            decoration: BoxDecoration(
                              color: accentOrange,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 15,
                            height: 5,
                            decoration: BoxDecoration(
                              color: accentOrange.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveIntro(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(children: [
        _buildIntroImage(),
        const SizedBox(height: 32),
        _buildIntroContent()
      ]),
    );
  }

  Widget _buildIntroImage() {
    return Container(
      height: 380, // Increased height from 300 to 380
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 25,
              offset: const Offset(0, 12))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Image.network(pastorChrisImageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                child: const Icon(LucideIcons.image_off, size: 40))),
      ),
    );
  }

  Widget _buildIntroContent() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildSectionHeader("Who We Are"),
      const SizedBox(height: 16),
      _buildIntroText(
          "LoveWorld Incorporated, (a.k.a Christ Embassy) is a global ministry with a vision of taking God’s divine presence to the nations."),
      const SizedBox(height: 16),
      _buildIntroText(
          "This is achieved through every available means, driven by a passion to see men and women come to the knowledge of the divine life."),
    ]);
  }

  Widget _buildSectionHeader(String title) {
    return Text(title.toUpperCase(),
        style: TextStyle(
            fontSize: 14,
            letterSpacing: 2,
            fontWeight: FontWeight.w900,
            color: primaryBlue));
  }

  Widget _buildIntroText(String text) {
    return Text(text,
        style: const TextStyle(
            fontSize: 16,
            height: 1.5,
            color: Color(0xFF334155),
            fontWeight: FontWeight.w400));
  }

  Widget _buildFeatureCard(
      {required IconData icon,
      required String title,
      required String description}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: primaryBlue, size: 24)),
        const SizedBox(width: 16),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A))),
          const SizedBox(height: 8),
          Text(description,
              style: const TextStyle(
                  fontSize: 14, height: 1.4, color: Color(0xFF64748B))),
        ])),
      ]),
    );
  }
}
