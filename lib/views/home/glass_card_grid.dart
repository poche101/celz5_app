import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_lucide/flutter_lucide.dart';

class GlassCardGrid extends StatelessWidget {
  final bool isMobile;
  final Function(int) onItemSelected;

  const GlassCardGrid(
      {super.key, required this.isMobile, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        // 2 columns on mobile, 6 on desktop
        crossAxisCount: isMobile ? 2 : 6,
        mainAxisSpacing: 16, // Standardized spacing
        crossAxisSpacing: 16,
        // Aspect ratio 1.0 makes them perfect squares
        childAspectRatio: 1.0,
        children: [
          _buildCard(LucideIcons.megaphone, "Testimony", 2),
          _buildCard(LucideIcons.sparkles, "Higher Life", 5),
          _buildCard(LucideIcons.calendar_check, "Events", 3),
          _buildCard(LucideIcons.book_open, "Our Blog", 4),
          _buildCard(LucideIcons.graduation_cap, "Foundation School", 9),
          _buildCard(LucideIcons.hand_helping, "Partnership Arms", 6),
        ],
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, int index) {
    return InkWell(
      onTap: () => onItemSelected(index),
      borderRadius: BorderRadius.circular(24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.6),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.orangeAccent,
                  size: isMobile ? 28 : 24, // Optimized icon sizing
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis, // Better for long titles
                  style: TextStyle(
                    // Standard Mobile Grid font size (13-14px)
                    fontSize: isMobile ? 14 : 13,
                    fontWeight: FontWeight.w700, // Bold but not overwhelming
                    color: const Color(
                        0xFF334155), // Slate 700 for better legibility
                    letterSpacing: -0.2,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
