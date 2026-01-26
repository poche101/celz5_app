import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class CelzNavbar extends StatelessWidget implements PreferredSizeWidget {
  const CelzNavbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  // The deep slate color provided
  static const Color navBgColor = Color(0xFF1E293B);

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 1100;

    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: navBgColor,
        border: Border(
          bottom: BorderSide(color: Colors.white10, width: 1),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              // MOBILE MENU ICON
              if (!isDesktop)
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(LucideIcons.menu, color: Colors.white),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),

              // LOGO
              const Text(
                "CELZ5",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                  letterSpacing: -0.5,
                ),
              ),

              const Spacer(),

              // DESKTOP NAVIGATION
              if (isDesktop) ..._buildDesktopMenu(context),

              const SizedBox(width: 20),

              // AUTH SECTION
              _buildAuthSection(context),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDesktopMenu(BuildContext context) {
    final List<Map<String, String>> navItems = [
      {'name': 'Home', 'route': '/dashboard'},
      {'name': 'About', 'route': '/about'},
      {'name': 'Testimonies', 'route': '/testimonies'},
      {'name': 'Higher Life', 'route': '/higher-life'},
      {'name': 'Blog', 'route': '/blog'},
      {'name': 'Events', 'route': '/events'},
      {'name': 'Live Stream', 'route': '/live-streams'},
    ];

    return navItems.map((item) {
      return _NavHoverItem(
        title: item['name']!,
        onTap: () {
          if (ModalRoute.of(context)?.settings.name != item['route']) {
            Navigator.pushNamed(context, item['route']!);
          }
        },
      );
    }).toList();
  }

  Widget _buildAuthSection(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // LOGIN BUTTON (Sleek Ghost Style)
        OutlinedButton.icon(
          onPressed: () => Navigator.pushNamed(context, '/login'),
          icon: const Icon(LucideIcons.log_in, size: 16, color: Colors.white),
          label: const Text("Login"),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white30),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(width: 16),

        // PROFILE DROPDOWN
        PopupMenuButton<String>(
          offset: const Offset(0, 55),
          // UPDATED: Now matches navbar color exactly
          color: navBgColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.white10), // Subtle border
          ),
          icon: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white12,
              child: Icon(LucideIcons.user, size: 18, color: Colors.white),
            ),
          ),
          onSelected: (value) {
            if (value == 'profile') Navigator.pushNamed(context, '/profile');
            if (value == 'logout') {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            }
          },
          itemBuilder: (context) => [
            _buildPopupItem(
                'profile', LucideIcons.user, "My Profile", Colors.white),
            _buildPopupItem(
                'logout', LucideIcons.log_out, "Logout", Colors.redAccent),
          ],
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupItem(
      String value, IconData icon, String text, Color color) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(color: color, fontSize: 14)),
        ],
      ),
    );
  }
}

// --- SLEEK HOVER ITEM COMPONENT ---

class _NavHoverItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const _NavHoverItem({required this.title, required this.onTap});

  @override
  State<_NavHoverItem> createState() => _NavHoverItemState();
}

class _NavHoverItemState extends State<_NavHoverItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _isHovered
                ? Colors.white.withOpacity(0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            widget.title,
            style: TextStyle(
              color: _isHovered ? Colors.white : Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
