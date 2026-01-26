import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// SHARED WIDGETS
import 'package:celz5_app/views/shared/church_sidebar.dart';
import 'package:celz5_app/views/shared/church_webview.dart';

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
// If you have a physical file for contacts, import it here:
// import 'package:celz5_app/views/contacts_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Celz5App());
}

class Celz5App extends StatelessWidget {
  const Celz5App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CELZ5 Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0A192F)),
        textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      initialRoute: '/home',
      routes: {
        // CONTENT ROUTES
        '/home': (context) => const HomeView(),
        '/about': (context) => const AboutView(),
        '/testimonies': (context) => const TestimoniesView(),
        '/events': (context) => const EventView(),
        '/blog': (context) => const BlogView(),
        '/higher-life': (context) => const HigherLifeView(),
        '/live-streams': (context) => const LiveStreamsView(),
        '/profile': (context) => const ProfileView(),
        '/contacts': (context) => const ChurchWebView(
              url: "https://kingsch.at",
              title: "Contact Us",
            ),

        // AUTH & SHELL ROUTES (Placed last as requested)
        '/login': (context) => auth.LoginView(),
        '/register': (context) => const RegisterView(),
        '/dashboard': (context) => const DashboardShell(),
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

  // FIX 1 & 2: Removed 'const' from the list and used real instances
  // This list now perfectly matches the index of your Sidebar
  final List<Widget> _pages = [
    const HomeView(), // Index 0
    const AboutView(), // Index 1
    const TestimoniesView(), // Index 2
    const EventView(), // Index 3
    const BlogView(), // Index 4
    const HigherLifeView(), // Index 5
    // FIX 3: Using the WebView for Contacts as intended
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
      body: Row(
        children: [
          ChurchSidebar(
            selectedIndex: _currentIndex,
            onItemSelected: (index) {
              if (index == 9) {
                _handleLogout(context);
              } else if (index >= 0 && index < _pages.length) {
                setState(() => _currentIndex = index);
              }
            },
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              // The IndexedStack ensures that when you switch tabs,
              // the state (like a video playing) is preserved.
              child: IndexedStack(
                index: _currentIndex,
                children: _pages,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Logout"),
        content: const Text("Are you sure you want to sign out of the portal?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
