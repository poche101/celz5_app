import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:celz5_app/views/shared/footer.dart'; // Ensure correct import path

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  final Color primaryDark = const Color(0xFF0A192F);
  final Color primaryBlue = const Color(0xFF0D47A1);
  final Color accentOrange = Colors.orangeAccent;

  // External image link for the introduction section
  final String pastorChrisImageUrl = "assets/images/p-chris.webp";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Elegant Header Banner ---
            _buildHeader(context),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48.0),
              child: Column(
                children: [
                  // --- Introduction Section (Split Layout) ---
                  _buildResponsiveIntro(context),

                  const SizedBox(height: 60),

                  // --- Vision & Purpose Grid ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader("Our Core Vision"),
                        const SizedBox(height: 24),
                        _buildFeatureCard(
                          icon: LucideIcons.eye,
                          title: "Our Vision",
                          description:
                              "Christ Embassy is not just a local assembly; it’s a vision. The Lord has called us to fulfill a very definite purpose, which is to take His divine presence to the peoples and nations of the world.",
                        ),
                        _buildFeatureCard(
                          icon: LucideIcons.church,
                          title: "More Than A Church",
                          description:
                              "When you come to Christ Embassy, you become part of something that’s more than a church; you become part of a great vision, God’s vision.",
                        ),
                        _buildFeatureCard(
                          icon: LucideIcons.sparkles,
                          title: "Giving Your Life Meaning",
                          description:
                              "You will hear that one Word from God that would bless you in a special way and revolutionize your life forever. More blessings will be established in your life.",
                        ),
                        _buildFeatureCard(
                          icon: LucideIcons.globe,
                          title: "Kingdom Advancers",
                          description:
                              "The Lord has called us to do big things for His Kingdom. Join us and let’s serve Him together, blessing the nations of the world.",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- Footer ---
            const CelzFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveIntro(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: isMobile
          ? Column(
              children: [
                _buildIntroImage(),
                const SizedBox(height: 32),
                _buildIntroContent(),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 2, child: _buildIntroImage()),
                const SizedBox(width: 48),
                Expanded(flex: 3, child: _buildIntroContent()),
              ],
            ),
    );
  }

  Widget _buildIntroImage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.network(
          pastorChrisImageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 300,
              color: Colors.grey[200],
              child: const Center(child: CircularProgressIndicator()),
            );
          },
          errorBuilder: (context, error, stackTrace) => Container(
            height: 300,
            color: Colors.grey[300],
            child: const Icon(LucideIcons.image_off, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildIntroContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Who We Are"),
        const SizedBox(height: 16),
        _buildIntroText(
            "LoveWorld Incorporated, (a.k.a Christ Embassy) is a global ministry with a vision of taking God’s divine presence to the nations of the world and to demonstrate the character of the Holy Spirit."),
        const SizedBox(height: 16),
        _buildIntroText(
            "This is achieved through every available means, as the Ministry is driven by a passion to see men and women all over the world, come to the knowledge of the divine life made available in Christ Jesus."),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
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
            right: -50,
            top: -20,
            child: Icon(LucideIcons.landmark,
                size: 280, color: Colors.white.withOpacity(0.05)),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IconButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/home'),
                    icon:
                        const Icon(LucideIcons.arrow_left, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "About Us",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 6,
                            decoration: BoxDecoration(
                              color: accentOrange,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 20,
                            height: 6,
                            decoration: BoxDecoration(
                              color: accentOrange,
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 14,
        letterSpacing: 2,
        fontWeight: FontWeight.w800,
        color: primaryBlue,
      ),
    );
  }

  Widget _buildIntroText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        height: 1.6,
        color: Color(0xFF334155),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildFeatureCard(
      {required IconData icon,
      required String title,
      required String description}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: primaryBlue, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
