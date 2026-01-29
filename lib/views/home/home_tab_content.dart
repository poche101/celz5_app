import 'package:flutter/material.dart';
import 'announcement_bar.dart';
import 'video_hero_section.dart';
import 'about_slider.dart';
import 'glass_card_grid.dart';
import 'higher_life_video.dart';
import 'package:celz5_app/views/shared/footer.dart';

class HomeTabContent extends StatelessWidget {
  final bool isMobile;
  final Function(int) onAction;

  const HomeTabContent(
      {super.key, required this.isMobile, required this.onAction});

  @override
  Widget build(BuildContext context) {
    // REMOVED: Expanded and SingleChildScrollView
    // We use a Column here because the parent (HomeView) is already a ListView
    return Column(
      mainAxisSize: MainAxisSize.min, // Tell column to wrap content
      children: [
        const AnnouncementBar(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: isMobile ? 16 / 10 : 16 / 6,
              child: VideoHeroSection(onAction: onAction),
            ),
            _buildSectionHeader("About Us", isMobile),
            const AboutSlider(),
            GlassCardGrid(isMobile: isMobile, onItemSelected: onAction),
            const HigherLifeVideoSection(),
            if (!isMobile) const CelzFooter(),
            // Only add extra space if it's the very bottom of the Column
            if (isMobile) const SizedBox(height: 20),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, bool isMobile) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, isMobile ? 32 : 40, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: isMobile ? 22 : 32,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0A192F))),
          const SizedBox(height: 8),
          Row(children: [
            Container(
                height: 3,
                width: 35,
                decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(10))),
            const SizedBox(width: 4),
            Container(
                height: 3,
                width: 8,
                decoration: BoxDecoration(
                    color: Colors.orangeAccent.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10))),
          ]),
        ],
      ),
    );
  }
}
