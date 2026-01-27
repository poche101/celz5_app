import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class CelzNavbar extends StatelessWidget implements PreferredSizeWidget {
  const CelzNavbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(85);

  static const Color navBgColor = Color(0xFF0A192F);
  static const Color dropdownBgColor = Color(0xFF112240);
  static const Color accentColor = Color(0xFF2196F3);

  static final List<Map<String, dynamic>> navItems = [
    {'name': 'Home', 'route': '/dashboard', 'icon': LucideIcons.house},
    {'name': 'About', 'route': '/about', 'icon': LucideIcons.info},
    {
      'name': 'Testimonies',
      'route': '/testimonies',
      'icon': LucideIcons.megaphone
    },
    {
      'name': 'Higher Life',
      'route': '/higher-life',
      'icon': LucideIcons.sparkles
    },
    {'name': 'Blog', 'route': '/blog', 'icon': LucideIcons.newspaper},
    {'name': 'Events', 'route': '/events', 'icon': LucideIcons.calendar},
    {
      'name': 'Live Stream',
      'route': '/live-streams',
      'icon': LucideIcons.monitor_play
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 1250;
    final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 85,
          decoration: BoxDecoration(
            color: navBgColor.withOpacity(0.9),
            border: const Border(bottom: BorderSide(color: Colors.white10)),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 15 : 40),
              child: Row(
                children: [
                  _buildFancifulLogo(context),
                  const Spacer(),
                  if (!isMobile) ...[
                    Row(
                      children: navItems.map((item) {
                        return _NavHoverItem(
                          title: item['name']!,
                          isActive: currentRoute == item['route'],
                          onTap: () =>
                              Navigator.of(context).pushNamed(item['route']!),
                        );
                      }).toList(),
                    ),
                    const SizedBox(width: 25),
                    _buildLoginButton(context),
                    const SizedBox(width: 15),
                    _buildProfileDropdown(context),
                  ],
                  if (isMobile)
                    // FIX: Builder provides the correct context to find the Scaffold
                    Builder(
                      builder: (scaffoldContext) => IconButton(
                        icon: const Icon(LucideIcons.menu,
                            color: Colors.white, size: 28),
                        onPressed: () {
                          // This specifically triggers the endDrawer (Right Side)
                          Scaffold.of(scaffoldContext).openEndDrawer();
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Logo and desktop buttons remain the same for consistency
  Widget _buildLoginButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed('/login'),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: accentColor.withOpacity(0.5), width: 1),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.log_in, color: Colors.white, size: 16),
              SizedBox(width: 8),
              Text("Login",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFancifulLogo(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed('/dashboard'),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/logo.png',
              height: 40,
              errorBuilder: (context, e, s) =>
                  const Icon(LucideIcons.church, color: Colors.white)),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("CHRIST EMBASSY",
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.1)),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFF64B5F6),
                    Color(0xFF2196F3),
                    Color(0xFF1565C0)
                  ],
                ).createShader(bounds),
                child: const Text("Lagos Zone 5",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 19,
                        letterSpacing: -0.5,
                        fontStyle: FontStyle.italic)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDropdown(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 60),
      color: dropdownBgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.white10)),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:
                Border.all(color: accentColor.withOpacity(0.5), width: 1.5)),
        child: const CircleAvatar(
          radius: 17,
          backgroundColor: Colors.white12,
          child: Icon(LucideIcons.circle_user, color: Colors.white, size: 20),
        ),
      ),
      onSelected: (value) => Navigator.of(context).pushNamed(value),
      itemBuilder: (context) => [
        _buildPopupItem('My Profile', LucideIcons.circle_user, "/profile"),
        _buildPopupItem('Settings', LucideIcons.settings, "/settings"),
        const PopupMenuDivider(),
        _buildPopupItem('Logout', LucideIcons.log_out, "/logout",
            color: Colors.redAccent),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupItem(
      String text, IconData icon, String value,
      {Color color = Colors.white}) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color.withOpacity(0.8)),
          const SizedBox(width: 12),
          Text(text,
              style: TextStyle(
                  color: color, fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// --- ANIMATED MOBILE DRAWER (Right to Left Slide) ---

class CelzMobileDrawer extends StatefulWidget {
  const CelzMobileDrawer({super.key});

  @override
  State<CelzMobileDrawer> createState() => _CelzMobileDrawerState();
}

class _CelzMobileDrawerState extends State<CelzMobileDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';

    final List<Map<String, dynamic>> allItems = [
      ...CelzNavbar.navItems,
      {
        'name': 'My Profile',
        'route': '/profile',
        'icon': LucideIcons.circle_user
      },
      {
        'name': 'Login',
        'route': '/login',
        'icon': LucideIcons.log_in,
        'isButton': true
      },
    ];

    return Drawer(
      backgroundColor: CelzNavbar.navBgColor,
      elevation: 20,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
              left:
                  BorderSide(color: Colors.white.withOpacity(0.05), width: 1)),
        ),
        child: Column(
          children: [
            _buildDrawerHeader(),
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                itemCount: allItems.length,
                itemBuilder: (context, index) {
                  // STAGGERED SLIDE-IN ANIMATION
                  final animation = CurvedAnimation(
                    parent: _controller,
                    curve: Interval(
                      (0.3 + (index * 0.06)).clamp(0, 1.0),
                      1.0,
                      curve: Curves.easeOutBack,
                    ),
                  );

                  return AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(80 * (1 - animation.value), 0),
                        child: Opacity(
                          opacity: animation.value,
                          child: child,
                        ),
                      );
                    },
                    child: _buildDrawerItem(
                        context, allItems[index], currentRoute),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 70, bottom: 40, left: 20, right: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF112240),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30)),
      ),
      child: Column(
        children: [
          const Text("CHRIST EMBASSY",
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF64B5F6), Color(0xFF2196F3)],
            ).createShader(bounds),
            child: const Text(
              "Lagos Zone 5",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 26,
                  fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            height: 2,
            width: 40,
            decoration: BoxDecoration(
              color: CelzNavbar.accentColor,
              borderRadius: BorderRadius.circular(10),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, Map<String, dynamic> item, String currentRoute) {
    bool isActive = currentRoute == item['route'];
    bool isButton = item['isButton'] ?? false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).pushNamed(item['route']);
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          // GLOW EFFECT FOR ACTIVE ITEM
          tileColor: isActive
              ? CelzNavbar.accentColor.withOpacity(0.15)
              : (isButton ? CelzNavbar.accentColor : Colors.transparent),
          leading: Icon(item['icon'],
              color: (isActive || isButton) ? Colors.white : Colors.white70,
              size: 22),
          title: Text(
            item['name'],
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight:
                  (isActive || isButton) ? FontWeight.bold : FontWeight.w400,
            ),
          ),
          trailing: isActive
              ? Icon(Icons.circle, size: 8, color: CelzNavbar.accentColor)
              : const Icon(LucideIcons.chevron_right,
                  color: Colors.white10, size: 16),
        ),
      ),
    );
  }
}

// --- ANIMATED HOVER ITEM (Desktop Only) ---
class _NavHoverItem extends StatefulWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;
  const _NavHoverItem(
      {required this.title, required this.isActive, required this.onTap});

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: (widget.isActive || _isHovered)
                      ? Colors.white
                      : Colors.white60,
                  fontWeight:
                      widget.isActive ? FontWeight.bold : FontWeight.w500,
                  fontSize: 14,
                ),
                child: Text(widget.title),
              ),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                height: 2.5,
                width: widget.isActive ? 24 : (_isHovered ? 16 : 0),
                decoration: BoxDecoration(
                  color: CelzNavbar.accentColor,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    if (widget.isActive || _isHovered)
                      BoxShadow(
                          color: CelzNavbar.accentColor.withOpacity(0.5),
                          blurRadius: 4,
                          spreadRadius: 1)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
