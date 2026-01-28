import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class CelzFooter extends StatelessWidget {
  const CelzFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 900;

        return Container(
          width: double.infinity,
          color: const Color(0xFF132238),
          padding: EdgeInsets.symmetric(
            vertical: 40,
            horizontal: isMobile ? 24 : 80,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
              const SizedBox(height: 40),
              const Divider(color: Colors.white10, thickness: 1),
              const SizedBox(height: 20),
              _buildBottomBar(isMobile),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: _brandSection()),
        const SizedBox(width: 40),
        Expanded(flex: 2, child: _linksSection()),
        Expanded(flex: 3, child: _contactSection()),
        Expanded(flex: 2, child: _socialsSection(false)),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _brandSection(),
        const SizedBox(height: 40),
        _linksSection(),
        const SizedBox(height: 40),
        _contactSection(),
        const SizedBox(height: 40),
        _socialsSection(true),
      ],
    );
  }

  Widget _brandSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(LucideIcons.church,
                      color: Colors.orangeAccent, size: 24),
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: _AnimatedHeader(
                title: "CHRIST EMBASSY\nLAGOS ZONE 5",
                isMainLogo: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          "LoveWorld Incorporated is a global ministry with a vision of taking God’s divine presence to the nations of the world and demonstrating the character of the Holy Spirit.",
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 13,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _linksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _AnimatedHeader(title: "QUICK LINKS"),
        const SizedBox(height: 20),
        ...["About Us", "Blog", "Events", "Testimonies", "FAQ"]
            .map((link) => _FooterLink(title: link)),
      ],
    );
  }

  Widget _contactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _AnimatedHeader(title: "CONTACT US"),
        const SizedBox(height: 20),
        _contactItem(LucideIcons.map_pin, "ADDRESS",
            "Loveworld Arena Lekki,\nAare Bashiru street, Chisco B/S,\nLekki-Epe Express Way"),
        _contactItem(LucideIcons.phone, "PHONE", "+234 800 123 4567"),
        _contactItem(LucideIcons.mail, "EMAIL", "info@celz5.org"),
      ],
    );
  }

  Widget _contactItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.orangeAccent.withOpacity(0.8), size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialsSection(bool isLeftAligned) {
    return Column(
      crossAxisAlignment:
          isLeftAligned ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        _AnimatedHeader(title: "FOLLOW US", isRightAligned: !isLeftAligned),
        const SizedBox(height: 20),
        // Changed runAlignment and alignment to ensure second line starts at the beginning
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            _socialIcon(LucideIcons.facebook),
            _socialIcon(LucideIcons.instagram),
            _socialIcon(
                LucideIcons.twitter), // Reverted back to the Twitter logo
            _socialIcon(LucideIcons.youtube),
            _socialIcon(LucideIcons.music_2),
            _socialIcon(LucideIcons.message_circle),
          ],
        ),
      ],
    );
  }

  Widget _socialIcon(IconData icon) {
    return _HoverScaleWrapper(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Icon(icon, color: Colors.white70, size: 18),
      ),
    );
  }

  Widget _buildBottomBar(bool isMobile) {
    return Flex(
      direction: isMobile ? Axis.vertical : Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "© 2026 CHRIST EMBASSY LAGOS ZONE 5 • ALL RIGHTS RESERVED",
          style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10),
        ),
        if (isMobile) const SizedBox(height: 12),
        Text(
          "",
          style: TextStyle(
            color: Colors.white.withOpacity(0.3),
            fontSize: 10,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

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
    final accentColor = Colors.orangeAccent;

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
            textAlign: widget.isRightAligned ? TextAlign.right : TextAlign.left,
            style: TextStyle(
              color: Colors.white,
              fontSize: widget.isMainLogo ? 16 : 12,
              height: 1.1,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _isHovered ? 50 : 30,
                height: 3,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: _isHovered ? 12 : 8,
                height: 3,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String title;
  const _FooterLink({required this.title});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.only(left: _isHovered ? 8 : 0),
          child: Text(
            widget.title,
            style: TextStyle(
              color: _isHovered
                  ? Colors.orangeAccent
                  : Colors.white.withOpacity(0.5),
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

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
