import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

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

// ADMIN & COMPONENT IMPORTS
import 'package:celz5_app/views/admin/admin_dashboard.dart';
// ADDED: Import for the blog post tab component
import 'package:celz5_app/views/admin/tabs/blog_posts_tab.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          primary: const Color(0xFF6366F1),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      initialRoute: '/',
      routes: {
        // Admin Routes
        '/': (context) => const AdminDashboard(),
        '/admin': (context) => const AdminDashboard(),

        // ADDED: Route to access the Blog Studio directly
        '/blog-post': (context) => const BlogPostTab(),

        // User/Member Routes
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
    const HomeView(),
    const AboutView(),
    const TestimonyView(),
    const EventView(),
    const BlogView(),
    const HigherLifeArchiveApp(),
    const ChurchWebView(
      url: "https://kingsch.at",
      title: "Contact Us / KingsChat",
    ),
    const LiveStreamsView(),
    const ProfileView(),
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
