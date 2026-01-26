import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:celz5_app/views/login_view.dart';

class ChurchSidebar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final bool isLoggedIn;

  const ChurchSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.isLoggedIn = false,
  });

  @override
  State<ChurchSidebar> createState() => _ChurchSidebarState();
}

class _ChurchSidebarState extends State<ChurchSidebar> {
  bool isExpanded = true;
  int? hoveredIndex;

  // Enhanced Popup Item with professional typography and spacing
  PopupMenuItem<int> _buildPopupItem(
      int value, IconData icon, String text, Color color) {
    return PopupMenuItem(
      value: value,
      height: 40,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color.withOpacity(0.7)),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A2A42),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Logout", style: TextStyle(color: Colors.white)),
          content: const Text("Are you sure you want to sign out?",
              style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text("Cancel", style: TextStyle(color: Colors.white38)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.withOpacity(0.1),
                foregroundColor: Colors.redAccent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(context);
                widget.onItemSelected(10);
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      width: isExpanded ? 280 : 80,
      decoration: BoxDecoration(
        color: const Color(0xFF0A192F),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(5, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              children: [
                _navItem(LucideIcons.house, "Home", 0),
                _navItem(LucideIcons.info, "About", 1),
                _navItem(LucideIcons.quote, "Testimonies", 2),
                _navItem(LucideIcons.calendar_days, "Events", 3),
                _navItem(LucideIcons.book_open, "Blog", 4),
                _navItem(LucideIcons.sparkles, "Higher Life", 5),
                _navItem(LucideIcons.phone, "Contacts", 6),
                _navItem(LucideIcons.circle_play, "Live Streams", 7),
              ],
            ),
          ),
          _buildProfileFooter(),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    bool isActive = widget.selectedIndex == index;
    bool isHovered = hoveredIndex == index;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: MouseRegion(
        onEnter: (_) => setState(() => hoveredIndex = index),
        onExit: (_) => setState(() => hoveredIndex = null),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => widget.onItemSelected(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.blueAccent.withOpacity(0.15)
                  : (isHovered
                      ? Colors.white.withOpacity(0.05)
                      : Colors.transparent),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: isExpanded
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: isExpanded ? 16 : 0),
                  child: Icon(icon,
                      color: isActive
                          ? Colors.blueAccent
                          : (isHovered ? Colors.white : Colors.white54),
                      size: 22),
                ),
                if (isExpanded) ...[
                  const SizedBox(width: 16),
                  Text(label,
                      style: TextStyle(
                          color: isActive
                              ? Colors.white
                              : (isHovered ? Colors.white : Colors.white54),
                          fontSize: 14)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 16, right: 10),
      child: Row(
        mainAxisAlignment: isExpanded
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: [
          if (isExpanded)
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("CHRIST EMBASSY",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.white,
                        letterSpacing: 1.2)),
                Text("Lagos Zone 5",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        color: Colors.blueAccent)),
              ],
            ),
          IconButton(
            onPressed: () => setState(() => isExpanded = !isExpanded),
            icon: Icon(
                isExpanded
                    ? LucideIcons.panel_left_close
                    : LucideIcons.panel_left_open,
                size: 20,
                color: Colors.white38),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileFooter() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment:
            isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          PopupMenuButton<int>(
            offset: const Offset(0, -105),
            color: const Color(0xFF132238),
            elevation: 10,
            position: PopupMenuPosition.under,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            onSelected: (value) {
              if (value == 8) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginView()));
              } else if (value == 10) {
                _showLogoutConfirmation();
              } else {
                widget.onItemSelected(value);
              }
            },
            itemBuilder: (context) => [
              if (!widget.isLoggedIn)
                _buildPopupItem(8, LucideIcons.log_in, "Login to Account",
                    Colors.blueAccent),
              if (widget.isLoggedIn) ...[
                _buildPopupItem(
                    9, LucideIcons.user, "View Profile", Colors.white),
                const PopupMenuDivider(height: 1),
                _buildPopupItem(
                    10, LucideIcons.log_out, "Logout", Colors.redAccent),
              ],
            ],
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: CircleAvatar(
                radius: 16,
                backgroundColor:
                    widget.isLoggedIn ? Colors.blueAccent : Colors.white12,
                child: Icon(
                  widget.isLoggedIn
                      ? LucideIcons.user
                      : LucideIcons.circle_user_round,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          if (isExpanded) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.isLoggedIn ? "Bro. Kings" : "Guest User",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.isLoggedIn ? "Media Team" : "Welcome",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}
