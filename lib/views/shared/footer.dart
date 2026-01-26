import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class CelzFooter extends StatelessWidget {
  const CelzFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 800;

    return Container(
      width: double.infinity,
      color: const Color(0xFF132238),
      padding: EdgeInsets.symmetric(
        vertical: 40,
        horizontal: isMobile ? 20 : 80,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- BRAND & MISSION ---
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _AnimatedHeader(title: "CELZ5", isMainLogo: true),
                    const SizedBox(height: 16),
                    Text(
                      "Spreading the message of the Higher Life to the ends of the earth through innovation and grace.",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              if (!isMobile) const Spacer(),

              // --- QUICK LINKS ---
              if (!isMobile)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _AnimatedHeader(title: "CHURCH"),
                      const SizedBox(height: 20),
                      ...["About", "Events", "Giving", "Privacy"]
                          .map((link) => _buildLinkItem(link)),
                    ],
                  ),
                ),

              // --- SOCIAL MEDIA SECTION ---
              Expanded(
                flex: isMobile ? 2 : 1,
                child: Column(
                  crossAxisAlignment: isMobile
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    const _AnimatedHeader(
                        title: "FOLLOW US", isRightAligned: true),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 10,
                      children: [
                        _socialIcon(LucideIcons.facebook),
                        _socialIcon(LucideIcons.instagram),
                        _socialIcon(LucideIcons.twitter),
                        _socialIcon(LucideIcons.youtube),
                        _socialIcon(LucideIcons.linkedin),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Divider(color: Colors.white10, thickness: 1),
          const SizedBox(height: 20),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildLinkItem(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Text(
          title,
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "© 2026 CELZ5 CONNECT",
          style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10),
        ),
        Text(
          "CHRIST EMBASSY • LAGOS ZONE 5",
          style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 10,
              letterSpacing: 1),
        ),
      ],
    );
  }

  Widget _socialIcon(IconData icon) {
    return _HoverScaleWrapper(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white70, size: 18),
      ),
    );
  }
}

/// --- CUSTOM ANIMATED HEADER WIDGET ---
class _AnimatedHeader extends StatefulWidget {
  final String title;
  final bool isMainLogo;
  final bool isRightAligned;

  const _AnimatedHeader({
    required this.title,
    this.isMainLogo = false,
    this.isRightAligned = false,
  });

  @override
  State<_AnimatedHeader> createState() => _AnimatedHeaderState();
}

class _AnimatedHeaderState extends State<_AnimatedHeader> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: widget.isRightAligned
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              color: widget.isMainLogo ? Colors.white : Colors.blueAccent,
              fontSize: widget.isMainLogo ? 24 : 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Stack(
            children: [
              // Part 1: The Long Background Line
              Container(
                width: 60,
                height: 2,
                color: Colors.white.withOpacity(0.1),
              ),
              // Part 2: The Short Animated Accent Line
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _isHovered ? 60 : 25,
                height: 2,
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// --- SOCIAL ICON HOVER ANIMATION ---
class _HoverScaleWrapper extends StatefulWidget {
  final Widget child;
  const _HoverScaleWrapper({required this.child});

  @override
  State<_HoverScaleWrapper> createState() => _HoverScaleWrapperState();
}

class _HoverScaleWrapperState extends State<_HoverScaleWrapper> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: widget.child,
      ),
    );
  }
}
