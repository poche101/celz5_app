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
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 120,
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
                height: 550,
                child: Stack(
                  children: [
                    _AboutCard(
                      index: 0,
                      title: "Our Vision",
                      description:
                          "To take God's divine presence to the nations and peoples of the world, demonstrating the character of the Holy Spirit through the preaching of the Gospel.",
                      icon: LucideIcons.eye,
                      color: const Color(0xFF0D47A1),
                      top: 0,
                      left: 0,
                    ),
                    _AboutCard(
                      index: 1,
                      title: "Our Mission",
                      description:
                          "To raise generations of men and women who will come into their inheritance to fulfill God’s dream. To make known and to bring them into their inheritance in Christ.",
                      icon: LucideIcons.target,
                      color: const Color(0xFF1976D2),
                      top: 60,
                      left: 60,
                    ),
                    _AboutCard(
                      index: 2,
                      title: "Worship With Us.",
                      description:
                          "Join a congregation of the mighty as we worship God in spirit and truth. You can participate both onsite and online from anywhere in the world.",
                      icon: LucideIcons.activity,
                      color: const Color(0xFF2196F3),
                      top: 120,
                      left: 120,
                    ),
                    _AboutCard(
                      index: 3,
                      title: "Who We Are",
                      description:
                          "A global family of believers united by the love of Christ, dedicated to spiritual excellence and the expansion of the Kingdom.",
                      icon: LucideIcons.users_round,
                      color: const Color(0xFF64B5F6),
                      top: 180,
                      left: 180,
                    ),
                  ],
                ),
              ),
            ),

          // Mobile Cards Grid (Shows only on mobile)
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
            fontWeight: FontWeight.w800,
            letterSpacing: 4,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Global Ministry with\na Divine Purpose",
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: isMobile ? 36 : 52,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0A192F),
            height: 1.1,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 24),

        // Restored Double Underline
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
                    height: 4,
                    width: 80,
                    decoration: BoxDecoration(
                        color: const Color(0xFF2196F3),
                        borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 4),
                Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                        color: const Color(0xFF2196F3).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2))),
              ],
            ),
          ],
        ),

        const SizedBox(height: 40),
        Text(
          "LoveWorld Incorporated, (a.k.a Christ Embassy) is a global ministry with a vision of taking God’s divine presence to the nations of the world and to demonstrate the character of the Holy Spirit.\n\nDriven by a passion to see men and women all over the world come to the knowledge of the divine life made available in Christ Jesus.",
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: 18,
            color: const Color(0xFF4A5568).withOpacity(0.8),
            height: 1.8,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 50),

        ElevatedButton.icon(
          onPressed: () => onReadMore(1),
          icon: const Icon(LucideIcons.arrow_right, size: 18),
          label: const Text("LEARN MORE ABOUT US"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0A192F),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 22),
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileCardsGrid() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          // Note: You can reuse _AboutCard here by passing smaller dimensions or
          // just list them vertically for better mobile UX.
        ],
      ),
    );
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

  void _showSleekDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(40),
            constraints: const BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 40)
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: color, size: 48),
                  const SizedBox(height: 24),
                  Text(title,
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: color)),
                  const SizedBox(height: 16),
                  Text(
                    description, // Text will never be cut here
                    style: const TextStyle(
                        fontSize: 18, height: 1.6, color: Color(0xFF4A5568)),
                  ),
                  const SizedBox(height: 32),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("CLOSE",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: TweenAnimationBuilder<double>(
        duration: Duration(milliseconds: 1000 + (index * 200)),
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.easeOutExpo,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(80 * (1 - value), 80 * (1 - value)),
            child: Opacity(opacity: value, child: child),
          );
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _showSleekDialog(context),
            child: Container(
              width: 280,
              height: 220, // Slightly taller for breathing room
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withAlpha(200)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.white, size: 26),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const Icon(LucideIcons.chevron_right,
                          color: Colors.white70, size: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
