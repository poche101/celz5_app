import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_web_plugins/url_strategy.dart'; // REQUIRED for clean URLs

// SHARED WIDGETS
import 'package:celz5_app/views/shared/church_webview.dart';
import 'package:celz5_app/views/home/bottom_navbar.dart';
import 'package:celz5_app/views/shared/social_floating_menu.dart';

// VIEW IMPORTS
import 'package:celz5_app/views/home_view.dart';
import 'package:celz5_app/views/about_view.dart';
import 'package:celz5_app/views/testimonies_view.dart';
import 'package:celz5_app/views/event_view.dart';
import 'package:celz5_app/views/blog_view.dart';
import 'package:celz5_app/views/higher_life_view.dart';
import 'package:celz5_app/views/live_streams_view.dart';
import 'package:celz5_app/views/login_view.dart' as auth;
import 'package:celz5_app/views/register_view.dart';
import 'package:celz5_app/views/profile_view.dart';
import 'package:celz5_app/views/event_register_view.dart';

// ADMIN IMPORT
import 'package:celz5_app/views/admin/admin_dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Call this BEFORE runApp to enable clean URLs like localhost:8080/admin
  usePathUrlStrategy();
  runApp(const Celz5App());
}

class Celz5App extends StatelessWidget {
  const Celz5App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CELZ5 Admin Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0A192F)),
        textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      // Setting initialRoute to '/' makes the AdminDashboard the first thing seen.
      initialRoute: '/',
      routes: {
        // Root path now loads AdminDashboard
        '/': (context) => const AdminDashboard(),
        '/admin': (context) => const AdminDashboard(),

        // Mobile/Member routes
        '/dashboard': (context) => const DashboardShell(),
        '/home': (context) => const HomeView(),
        '/about': (context) => const AboutView(),
        '/testimonies': (context) => const TestimonyView(),
        '/events': (context) => const EventView(),
        '/event-register': (context) => const EventRegisterView(),
        '/blog': (context) => const BlogView(),
        '/higher-life': (context) => const HigherLifeArchiveApp(),
        '/live-streams': (context) => const LiveStreamsView(),
        '/profile': (context) => const ProfileView(),
        '/contacts': (context) => const ChurchWebView(
              url: "https://kingsch.at",
              title: "Contact Us",
            ),
        '/login_view': (context) => const auth.LoginView(),
        '/register': (context) => const RegisterView(),
      },
    );
  }
}

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeView(), // Index 0
    const AboutView(), // Index 1
    const TestimonyView(), // Index 2
    const EventView(), // Index 3
    const BlogView(), // Index 4
    const HigherLifeArchiveApp(), // Index 5
    const ChurchWebView(
      url: "https://kingsch.at",
      title: "Contact Us / KingsChat",
    ), // Index 6
    const LiveStreamsView(), // Index 7
    const ProfileView(), // Index 8
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      floatingActionButton: const SocialFloatingMenu(),
      bottomNavigationBar: ScrollingBottomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
