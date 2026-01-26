import 'package:flutter/material.dart';
// FIX 1: Use the updated import
import 'package:flutter_lucide/flutter_lucide.dart';

class CelzFooter extends StatelessWidget {
  const CelzFooter({super.key});

  @override
  Widget build(BuildContext context) {
    // FIX 2: Better responsiveness threshold for Footers
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 700;

    return Container(
      width: double.infinity,
      color: const Color(0xFF0A192F),
      padding: EdgeInsets.symmetric(
        vertical: 60,
        horizontal: isMobile ? 20 : 60,
      ),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 40,
            runSpacing: 40,
            children: [
              // Brand Section
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isMobile ? screenWidth : 400,
                ),
                child: Column(
                  crossAxisAlignment: isMobile
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "CELZ5",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Spreading the message of the Higher Life to the ends of the earth. Join us in our global mission.",
                      textAlign: isMobile ? TextAlign.center : TextAlign.start,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Social Icons Section
              Column(
                crossAxisAlignment: isMobile
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.end,
                children: [
                  const Text(
                    "CONNECT WITH US",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _socialIcon(LucideIcons.instagram),
                      const SizedBox(width: 24),
                      _socialIcon(LucideIcons.youtube),
                      const SizedBox(width: 24),
                      _socialIcon(LucideIcons.facebook),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 60),
          // FIX 3: Using white12 instead of indexed grey to avoid null-safety/const issues
          const Divider(color: Colors.white12, thickness: 1),
          const SizedBox(height: 30),

          Text(
            "© 2026 CELZ5 CONNECT • CHRIST EMBASSY • ALL RIGHTS RESERVED",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 11,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialIcon(IconData icon) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Icon(
        icon,
        color: Colors.white,
        size: 26, // FIX 4: Slightly larger for industry-standard legibility
      ),
    );
  }
}
