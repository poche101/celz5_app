import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_lucide/flutter_lucide.dart';

class BlogSection extends StatelessWidget {
  final Function(int) onAction;

  BlogSection({super.key, required this.onAction});

  // Target index for the Blog View
  static const int blogViewIndex = 4;

  final List<Map<String, dynamic>> blogPosts = [
    {
      'category': 'HEALTH',
      'title': 'Vitality: Your Body is God\'s Temple',
      'subtitle': 'Practical biblical steps to maintaining peak wellness.',
      'icon': LucideIcons.leaf,
      'image': 'assets/images/health.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildSectionHeader(),
        const SizedBox(height: 30),
        Center(
          child: _buildElegantCard(context, blogPosts[0]),
        ),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Our Blog",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0A192F),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              height: 4,
              width: 12,
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildElegantCard(BuildContext context, Map<String, dynamic> post) {
    return Container(
      width: 340,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Image.asset(
                    post['image'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      color: Colors.white.withOpacity(0.2),
                      child: Icon(post['icon'], color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                post['category'],
                style: const TextStyle(
                  color: Colors.orangeAccent,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 8),
              const CircleAvatar(radius: 2, backgroundColor: Colors.grey),
              const SizedBox(width: 8),
              const Text(
                "5 min read",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            post['title'],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A192F),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            post['subtitle'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),

          // Updated Read More Link
          InkWell(
            onTap: () => onAction(blogViewIndex),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Read More",
                    style: TextStyle(
                      color: Color(0xFF0A192F),
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.arrow_right,
                      size: 14,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
