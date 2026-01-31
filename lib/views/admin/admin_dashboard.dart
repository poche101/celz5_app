import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
// Import your new page files here once created:
import 'package:celz5_app/views/admin/tabs/blog_posts_tab.dart';
import 'package:celz5_app/views/admin/tabs/testimonies_tab.dart';
import 'package:celz5_app/views/admin/tabs/events_tab.dart';
import 'package:celz5_app/views/admin/tabs/videos_tab.dart';
import 'package:celz5_app/views/admin/tabs/live_stream_tab.dart';
import 'package:celz5_app/views/admin/tabs/members_tab.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  final _meetingTitleController = TextEditingController();
  final _streamLinkController = TextEditingController();

  @override
  void dispose() {
    _meetingTitleController.dispose();
    _streamLinkController.dispose();
    super.dispose();
  }

  // --- PAGE SWITCHER LOGIC ---
// --- PAGE SWITCHER LOGIC ---
  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardContent(); // Dashboard Stats (Key 0 inside)
      case 1:
        // Swapping the Text for your actual Blog Dashboard
        return const BlogPostTab(key: ValueKey(1));
      case 2:
        return const TestimoniesTab(key: ValueKey(2));
      case 3:
        return const EventTab(key: ValueKey(3));
      case 4:
        return const VideoTab(key: ValueKey(4));
      case 5:
        return const LiveStreamTab(key: ValueKey(5));
      case 6:
        return const MemberTab(key: ValueKey(6));
      default:
        return _buildDashboardContent();
    }
  }

  void _showCreateMeetingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Schedule New Meeting",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF0A192F))),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogField("Meeting Title", "e.g. Sunday Service",
                  LucideIcons.heading, _meetingTitleController),
              const SizedBox(height: 16),
              _buildDialogField("Stream Link", "https://youtube.com/live/...",
                  LucideIcons.link, _streamLinkController),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A192F),
                foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Meeting Created")));
            },
            child: const Text("Create Meeting"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Row(
        children: [
          // --- SIDEBAR ---
          Container(
            width: 260,
            color: const Color(0xFF0A192F),
            child: Column(
              children: [
                _buildSidebarHeader(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    children: [
                      _sidebarItem(
                          0, "Dashboard", LucideIcons.layout_dashboard),
                      _sidebarItem(1, "Blog Posts", LucideIcons.file_text),
                      _sidebarItem(
                          2, "Testimonies", LucideIcons.heart_handshake),
                      _sidebarItem(3, "Events", LucideIcons.calendar),
                      _sidebarItem(4, "Higher Life Videos", LucideIcons.video),
                      _sidebarItem(5, "Live Stream", LucideIcons.radio),
                      _sidebarItem(6, "Members", LucideIcons.users),
                    ],
                  ),
                ),
                _buildSidebarFooter(),
              ],
            ),
          ),

          // --- MAIN CONTENT ---
          Expanded(
            child: Column(
              children: [
                _buildDesktopHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(40),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _getSelectedPage(), // This swaps the content
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          // Logo from Assets
          Image.asset(
            'assets/images/logo.png',
            height: 32,
            width: 32,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(LucideIcons.layout_template, color: Colors.amber),
          ),
          const SizedBox(width: 12),
          const Text("ADMIN",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2)),
        ],
      ),
    );
  }

  // ... (Keep your _sidebarItem, _buildDesktopHeader, _statCard, _actionTile, etc. from previous code)

  Widget _sidebarItem(int index, String label, IconData icon) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isSelected ? const Color(0xFFEAB308) : Colors.white60,
                size: 20),
            const SizedBox(width: 16),
            Text(label,
                style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white60,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    return Column(
      key: const ValueKey(0), // Key needed for AnimatedSwitcher
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _statCard(
                "Total Members", "12,840", LucideIcons.users, Colors.blue),
            const SizedBox(width: 24),
            _statCard(
                "Stream Attendance", "3,102", LucideIcons.radio, Colors.red),
            const SizedBox(width: 24),
            _statCard(
                "Pending Testimonies", "14", LucideIcons.heart, Colors.orange),
          ],
        ),
        const SizedBox(height: 40),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: _buildQuickActions()),
            const SizedBox(width: 24),
            Expanded(flex: 1, child: _buildRecentActivity()),
          ],
        ),
      ],
    );
  }

  // --- REUSE YOUR EXISTING HELPER WIDGETS BELOW ---
  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, color: color, size: 20)),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("System Management",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 2.5,
          children: [
            _actionTile("Create Meeting", "Setup live stream link",
                LucideIcons.circle_plus, _showCreateMeetingDialog),
            _actionTile("Upload Video", "Add Higher Life content",
                LucideIcons.cloud_upload, () {}),
            _actionTile(
                "Post Blog", "Write new article", LucideIcons.file_plus, () {}),
            _actionTile("Review Testimonies", "Approve pending submissions",
                LucideIcons.circle_check, () {}),
          ],
        ),
      ],
    );
  }

  Widget _actionTile(
      String title, String sub, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF0A192F), size: 28),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Text(sub,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Live Stream Chat",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 20),
          Text("No active comments...", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildDesktopHeader() {
    return Container(
      height: 80,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Welcome back, Admin",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("CE Lagos Zone 5 Dashboard",
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const Spacer(),
          _headerActionIcon(LucideIcons.search),
          _headerActionIcon(LucideIcons.bell),
          const VerticalDivider(indent: 25, endIndent: 25, width: 40),
          const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFF0A192F),
              child: Icon(LucideIcons.user, size: 18, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildDialogField(String label, String hint, IconData icon,
      TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18),
            hintText: hint,
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300)),
          ),
        ),
      ],
    );
  }

  Widget _headerActionIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Icon(icon, color: Colors.grey, size: 20),
    );
  }

  Widget _buildSidebarFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: _sidebarItem(99, "Logout", LucideIcons.log_out),
    );
  }
}
