import 'package:flutter/material.dart';

// Shared Components
import 'package:celz5_app/views/shared/navbar.dart';
import 'package:celz5_app/views/shared/footer.dart';

// Home-Specific Refactored Components
import 'home/announcement_bar.dart';
import 'home/video_hero_section.dart';
import 'home/about_section.dart';

// Individual Views
import 'package:celz5_app/views/about_view.dart';
import 'package:celz5_app/views/testimonies_view.dart';
import 'package:celz5_app/views/event_view.dart';
import 'package:celz5_app/views/blog_view.dart';
import 'package:celz5_app/views/higher_life_view.dart';
import 'package:celz5_app/views/contacts_view.dart';
import 'package:celz5_app/views/live_streams_view.dart';
import 'package:celz5_app/views/profile_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  void _onItemSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: const CelzNavbar(),
      endDrawer: const CelzMobileDrawer(),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeTabContent(), // Index 0 (Now Sticky)
          const AboutView(), // Index 1
          const TestimonyView(), // Index 2
          const EventView(), // Index 3
          const BlogView(), // Index 4
          const HigherLifeArchiveApp(), // Index 5
          const ContactView(), // Index 6
          const LiveStreamsView(), // Index 7
          const SizedBox.shrink(), // Index 8
          const ProfileView(), // Index 9
        ],
      ),
    );
  }

  /// Builds the Home Tab with a Sticky Announcement Bar
  Widget _buildHomeTabContent() {
    return Column(
      children: [
        // 1. STICKY ELEMENT: Stays at the top
        const AnnouncementBar(),

        // 2. SCROLLABLE ELEMENT: The rest of the page
        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                VideoHeroSection(onAction: _onItemSelected),
                HomeAboutSection(onReadMore: _onItemSelected),
                _buildWelcomeSection(),
                const CelzFooter(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 30),
      color: const Color(0xFFF5F7FA),
      child: Column(
        children: [
          const Text(
            "Welcome to CELZ5",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A192F),
            ),
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: const Text(
              "Spreading the message of the gospel to the ends of the earth. Join a community of believers dedicated to spiritual growth and global impact.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
