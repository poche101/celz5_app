import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'dart:ui';

class PrayerOfSalvation extends StatelessWidget {
  const PrayerOfSalvation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      height: 520, // Increased slightly to ensure button breathing room
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A192F).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            // 1. Background Image with a placeholder optimized for the theme
            Positioned.fill(
              child: Image.network(
                'https://images.unsplash.com/photo-1507692049790-de58290a4334?q=80&w=2070',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: const Color(0xFF0A192F)),
              ),
            ),

            // 2. Sophisticated Blue Overlay (Gradient)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF0A192F).withOpacity(0.5),
                      const Color(0xFF1A365D).withOpacity(0.85),
                      const Color(0xFF0A192F).withOpacity(0.95),
                    ],
                  ),
                ),
              ),
            ),

            // 3. Content Layer
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    LucideIcons.heart_handshake,
                    color: Colors.orangeAccent,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "PRAYER OF SALVATION",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Non-const container because color uses opacity
                  Container(
                    height: 2,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // The Prayer Text
                  const Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Text(
                        "“O Lord God, I believe with all my heart in Jesus Christ, Son of the living God. I believe He died for me and God raised Him from the dead. I believe He’s alive today. I confess with my mouth that Jesus Christ is the Lord of my life from this day. Through Him and His Name, I have eternal life; I’m born again. Thank you Lord, for saving my soul! I’m now a child of God. Hallelujah!”",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          height: 1.6,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Logic for conversion tracking or showing a 'Welcome Home' dialog
                      },
                      // Corrected Icon getter for flutter_lucide
                      icon: const Icon(LucideIcons.circle_check, size: 20),
                      label: const Text(
                        "I JUST PRAYED THIS",
                        style: TextStyle(
                            fontWeight: FontWeight.w800, letterSpacing: 1),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
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
}
