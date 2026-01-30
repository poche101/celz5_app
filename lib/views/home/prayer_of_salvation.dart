import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class PrayerOfSalvation extends StatelessWidget {
  const PrayerOfSalvation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      // Set height to be responsive or constrained for mobile
      constraints: const BoxConstraints(minHeight: 520, maxHeight: 650),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A192F).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // 1. Background Image
            Positioned.fill(
              child: Image.network(
                'https://images.unsplash.com/photo-1507692049790-de58290a4334?q=80&w=2070',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: const Color(0xFF0A192F)),
              ),
            ),

            // 2. Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF0A192F).withOpacity(0.7),
                      const Color(0xFF1A365D).withOpacity(0.9),
                      const Color(0xFF0A192F).withOpacity(1.0),
                    ],
                  ),
                ),
              ),
            ),

            // 3. Content Layer
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    LucideIcons.heart_handshake,
                    color: Colors.orangeAccent,
                    size: 48, // Standardized icon size
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "PRAYER OF SALVATION",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22, // Standard Mobile Header size
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 2,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // The Prayer Text
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Text(
                          "“O Lord God, I believe with all my heart in Jesus Christ, Son of the living God. I believe He died for me and God raised Him from the dead. I believe He’s alive today. I confess with my mouth that Jesus Christ is the Lord of my life from this day. Through Him and His Name, I have eternal life; I’m born again. Thank you Lord, for saving my soul! I’m now a child of God. Hallelujah!”",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.95),
                            fontSize:
                                17, // Optimized Body Text size for readability
                            height: 1.6,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 56, // Standard mobile button height
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showConfirmation(context);
                      },
                      icon: const Icon(LucideIcons.circle_check, size: 20),
                      label: const Text(
                        "I JUST PRAYED THIS",
                        style: TextStyle(
                          fontSize: 14, // Standard button text size
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
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

  void _showConfirmation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Welcome to the family of God!"),
        backgroundColor: Colors.orangeAccent,
      ),
    );
  }
}
