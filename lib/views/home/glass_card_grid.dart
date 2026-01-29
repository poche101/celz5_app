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
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: isMobile ? 3 : 6,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.5)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.orangeAccent),
                const SizedBox(height: 8),
                Text(title,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
