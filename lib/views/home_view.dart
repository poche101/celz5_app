import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// UI Components
import 'home/home_tab_content.dart';
import 'home/bottom_navbar.dart';
import 'home/blog_section.dart';
import 'home/contact_section.dart';
import 'home/prayer_of_salvation.dart'; // Added Prayer Section Import
import 'package:celz5_app/views/shared/navbar.dart';
import 'package:celz5_app/views/shared/church_webview.dart';
import 'package:celz5_app/views/home/mobile_drawer.dart' as custom;

// Individual Views
import 'package:celz5_app/views/about_view.dart';
import 'package:celz5_app/views/testimonies_view.dart';
import 'package:celz5_app/views/event_view.dart';
import 'package:celz5_app/views/blog_view.dart';
import 'package:celz5_app/views/higher_life_view.dart';
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
    if (_selectedIndex != index) {
      HapticFeedback.lightImpact();
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isMobile = size.width < 1100;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: isMobile ? null : const CelzNavbar(),
      endDrawer: custom.CelzMobileDrawer(
        onItemSelected: _onItemSelected,
        currentIndex: _selectedIndex,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Index 0: Main Home Scroll Experience
          ListView(
            key: const PageStorageKey('home_main_scroll'),
            physics: const BouncingScrollPhysics(),
            children: [
              // 1. Hero / Header Content
              HomeTabContent(isMobile: isMobile, onAction: _onItemSelected),
              const SizedBox(height: 12),

              // 2. Blog Section
              BlogSection(onAction: _onItemSelected),

              const SizedBox(height: 20),

              // 3. Prayer of Salvation Section (New)
              const PrayerOfSalvation(),

              const SizedBox(height: 40),

              // 4. Contact Section
              const ContactSection(),

              const SizedBox(height: 100), // Spacing for Bottom Navbar padding
            ],
          ),

          // Navigation Views for Bottom Navbar/Drawer
          const AboutView(), // 1
          const TestimonyView(), // 2
          const EventView(), // 3
          const BlogView(), // 4
          const HigherLifeArchiveApp(), // 5
          const ChurchWebView(
              // 6
              url: "https://kingsch.at",
              title: "KingsChat"),
          const LiveStreamsView(), // 7
          const ProfileView(), // 8
          const Center(child: Text("Foundation School View")), // 9
        ],
      ),
      bottomNavigationBar: isMobile
          ? ScrollingBottomNavbar(
              currentIndex: _selectedIndex,
              onTap: _onItemSelected,
            )
          : null,
    );
  }
}
