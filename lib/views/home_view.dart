import 'package:flutter/material.dart';

// Shared Components
import 'package:celz5_app/views/shared/church_sidebar.dart';
import 'package:celz5_app/views/shared/footer.dart';

// Individual Views
import 'package:celz5_app/views/about_view.dart';
import 'package:celz5_app/views/testimonies_view.dart';
import 'package:celz5_app/views/event_view.dart';
import 'package:celz5_app/views/blog_view.dart';
import 'package:celz5_app/views/higher_life_view.dart';
import 'package:celz5_app/views/contacts_view.dart';
import 'package:celz5_app/views/live_streams_view.dart';
import 'package:celz5_app/views/profile_view.dart';
import 'package:celz5_app/views/login_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  bool _isLoggedIn = true;

  void _onItemSelected(int index) {
    // Handling specific actions based on index
    switch (index) {
      case 8: // LOGIN
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        ).then((_) => setState(() {})); // Re-sync state on return
        break;

      case 10: // LOGOUT
        setState(() {
          _isLoggedIn = false;
          _selectedIndex = 0; // Reset to Home
        });
        break;

      default: // ALL OTHER PAGES
        setState(() {
          _selectedIndex = index;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light neutral background
      body: Row(
        children: [
          // 1. Sidebar remains static on the left
          ChurchSidebar(
            selectedIndex: _selectedIndex,
            onItemSelected: _onItemSelected,
            isLoggedIn: _isLoggedIn,
          ),

          // 2. Main content area changes based on index
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildHomeScreenContent(), // 0
                const AboutView(), // 1
                const TestimoniesView(), // 2
                const EventView(), // 3
                const BlogView(), // 4
                const HigherLifeView(), // 5
                const ContactView(), // 6
                const LiveStreamsView(), // 7
                const SizedBox
                    .shrink(), // 8 (Placeholder, handled by Navigator)
                const ProfileView(), // 9
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeScreenContent() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(), // Prevents bouncy gaps on web
      child: Column(
        children: [
          _buildHeroSection(),
          _buildWelcomeSection(),
          const CelzFooter(),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 30),
      child: Column(
        children: [
          const Text(
            "Welcome to CELZ5",
            style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A192F)),
          ),
          const SizedBox(height: 24),
          const Text(
            "Spreading the message of the gospel to the ends of the earth.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.black54, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.75, // Adjust height to be responsive
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/hero_bg.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "EXPERIENCE THE EXTRAORDINARY",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 52,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _onItemSelected(7), // Jump to Live Streams
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A192F),
                padding:
                    const EdgeInsets.symmetric(horizontal: 45, vertical: 22),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
              child: const Text(
                "JOIN US LIVE",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
