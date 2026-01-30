import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class HomeAboutSection extends StatelessWidget {
  final Function(int) onReadMore;

  const HomeAboutSection({super.key, required this.onReadMore});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 1100;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 100 : 200, // Increased breathing room
        horizontal: MediaQuery.of(context).size.width * 0.08,
      ),
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Side: Text Content
          Expanded(
            flex: isMobile ? 0 : 6,
            child: _buildTextContent(isMobile),
          ),

          if (!isMobile) const Spacer(flex: 1),

          // Right Side: Animated Stacking Cards
          if (!isMobile)
            Expanded(
              flex: 5,
              child: SizedBox(
                height: 750, // Increased height for larger card offsets
                child: Stack(
                  children: [
                    _AboutCard(
                      index: 0,
                      title: "Our Vision",
                      description:
                          "To take God's divine presence to the nations...",
                      icon: LucideIcons.eye,
                      color: const Color(0xFF0D47A1),
                      top: 0,
                      left: 0,
                    ),
                    _AboutCard(
                      index: 1,
                      title: "Our Mission",
                      description: "To raise generations of men and women...",
                      icon: LucideIcons.target,
                      color: const Color(0xFF1976D2),
                      top: 80, // Increased offset
                      left: 80,
                    ),
                    _AboutCard(
                      index: 2,
                      title: "Worship With Us",
                      description: "Join a congregation of the mighty...",
                      icon: LucideIcons.activity,
                      color: const Color(0xFF2196F3),
                      top: 160,
                      left: 160,
                    ),
                    _AboutCard(
                      index: 3,
                      title: "Who We Are",
                      description: "A global family of believers...",
                      icon: LucideIcons.users_round,
                      color: const Color(0xFF64B5F6),
                      top: 240,
                      left: 240,
                    ),
                  ],
                ),
              ),
            ),
          if (isMobile) _buildMobileCardsGrid(),
        ],
      ),
    );
  }

  Widget _buildTextContent(bool isMobile) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          "ABOUT US",
          style: TextStyle(
            color: const Color(0xFF2196F3),
            fontWeight: FontWeight.w500,
            letterSpacing: 10, // Wider tracking
            fontSize: 22, // Increased
          ),
        ),
        const SizedBox(height: 30),
        Text(
          "Global Ministry with\na Divine Purpose",
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: isMobile ? 58 : 96, // Huge hero size
            fontWeight: FontWeight.w200,
            color: const Color(0xFF0A192F),
            height: 1.0, // Tighter leading for large text
            letterSpacing: -3.0,
          ),
        ),
        const SizedBox(height: 50),
        // Decorative bars
        Row(
          mainAxisAlignment:
              isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: isMobile
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                Container(
                    height: 4, width: 140, color: const Color(0xFF2196F3)),
                const SizedBox(height: 10),
                Container(
                    height: 4,
                    width: 70,
                    color: const Color(0xFF2196F3).withOpacity(0.2)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 60),
        Text(
          "LoveWorld Incorporated, (a.k.a Christ Embassy) is a global ministry with a vision of taking God’s divine presence to the nations of the world and to demonstrate the character of the Holy Spirit.\n\nDriven by a passion to see men and women all over the world come to the knowledge of the divine life made available in Christ Jesus.",
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: 28, // High-readability size
            color: const Color(0xFF4A5568).withOpacity(0.85),
            height: 1.7,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 80),
        ElevatedButton.icon(
          onPressed: () => onReadMore(1),
          icon: const Icon(LucideIcons.arrow_right, size: 28),
          label: const Text("LEARN MORE ABOUT US"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0A192F),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 35),
            textStyle: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w400, letterSpacing: 3),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileCardsGrid() {
    return const Padding(padding: EdgeInsets.only(top: 100), child: SizedBox());
  }
}

class _AboutCard extends StatelessWidget {
  final int index;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final double top, left;

  const _AboutCard({
    required this.index,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.top,
    required this.left,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onTap: () => /* same dialog logic as before */ null,
        child: Container(
          width: 380, // Wider card
          height: 320, // Taller card
          padding: const EdgeInsets.all(50),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(45),
            boxShadow: [
              BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 50,
                  offset: const Offset(0, 25))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white, size: 48), // Larger icon
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40, // Much larger card title
                  fontWeight: FontWeight.w200,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
