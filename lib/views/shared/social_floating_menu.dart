import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialFloatingMenu extends StatefulWidget {
  const SocialFloatingMenu({super.key});

  @override
  State<SocialFloatingMenu> createState() => _SocialFloatingMenuState();
}

class _SocialFloatingMenuState extends State<SocialFloatingMenu>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _controller;

  // 1. Updated Social List with TikTok included
  final List<Map<String, dynamic>> _socials = [
    {
      'icon': LucideIcons.phone,
      'color': Colors.green,
      'url': 'tel:+2349076415312',
      'isTikTok': false
    },
    {
      'icon': LucideIcons.facebook,
      'color': const Color(0xFF1877F2),
      'url': 'https://www.facebook.com/CeLagosZone5',
      'isTikTok': false
    },
    {
      'icon': LucideIcons.twitter,
      'color': const Color(0xFF000000),
      'url': 'https://x.com/celagoszone5?s=21',
      'isTikTok': false
    },
    {
      'icon': LucideIcons.instagram,
      'color': const Color(0xFFE4405F),
      'url': 'https://www.instagram.com/celagoszone5',
      'isTikTok': false
    },
    {
      'icon': LucideIcons.music,
      'color': Colors.black,
      'url':
          'href="https://www.tiktok.com/@celagoszone5?_t=ZS-901lTpU4obf&_r=1',
      'isTikTok': true
    }, // TikTok
    {
      'icon': LucideIcons.youtube,
      'color': const Color(0xFFFF0000),
      'url': 'https://youtube.com/c/celz5',
      'isTikTok': false
    },
    {
      'icon': LucideIcons.message_circle,
      'color': const Color(0xFF00AEEF),
      'url': 'href="https://www.kingsch.at/p/eUM3MVd',
      'isTikTok': false
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700), // Snappy staggered duration
      vsync: this,
    );
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      _isOpen ? _controller.forward() : _controller.reverse();
    });
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, bottom: 16),
      child: SingleChildScrollView(
        // <--- Added this
        clipBehavior: Clip.none, // <--- Keeps shadows visible
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Items fountain out from the bottom
            ...List.generate(_socials.length, (index) {
              int reversedIndex = _socials.length - 1 - index;
              return _buildMenuItem(reversedIndex);
            }),

            const SizedBox(height: 16),

            // Main Trigger (80px)
            SizedBox(
              height: 80,
              width: 80,
              child: FloatingActionButton(
                backgroundColor: _isOpen ? Colors.white : Colors.orangeAccent,
                elevation: 8,
                onPressed: _toggle,
                shape: const CircleBorder(),
                child: AnimatedRotation(
                  turns: _isOpen ? 0.125 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    _isOpen
                        ? LucideIcons.plus
                        : LucideIcons.message_square_more,
                    color: _isOpen ? Colors.orangeAccent : Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(int index) {
    // Stagger logic: Start times are spread out
    final double start = (index * 0.08).clamp(0.0, 1.0);
    final double end = (start + 0.5).clamp(0.0, 1.0);

    final CurvedAnimation itemAnimation = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.elasticOut),
      reverseCurve: Curves.easeInBack,
    );

    return ScaleTransition(
      scale: itemAnimation,
      child: FadeTransition(
        opacity: itemAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: GestureDetector(
            onTap: () {
              _launchURL(_socials[index]['url']);
              _toggle();
            },
            child: Container(
              height: 70, // Massive sub-items
              width: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Center(
                child: _socials[index]['isTikTok']
                    ? _buildTikTokIcon()
                    : Icon(
                        _socials[index]['icon'],
                        color: _socials[index]['color'],
                        size: 34,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Specialized TikTok icon with the "glitch" effect
  Widget _buildTikTokIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Cyan Shadow
        Transform.translate(
          offset: const Offset(-2, -1),
          child:
              const Icon(LucideIcons.music, color: Color(0xFF25F4EE), size: 34),
        ),
        // Red Shadow
        Transform.translate(
          offset: const Offset(2, 1),
          child:
              const Icon(LucideIcons.music, color: Color(0xFFFE2C55), size: 34),
        ),
        // Main Black Note
        const Icon(LucideIcons.music, color: Colors.black, size: 34),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
