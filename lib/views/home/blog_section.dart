import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_lucide/flutter_lucide.dart';

// 1. Data Model for API Consistency
class BlogPost {
  final String category;
  final String title;
  final String subtitle;
  final IconData icon;
  final String imageUrl;
  final String readTime;

  BlogPost({
    required this.category,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.imageUrl,
    required this.readTime,
  });

  // Factory to convert JSON from your API
  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      category: json['category'] ?? 'GENERAL',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      // Map category string to IconData
      icon: _mapIconToCategory(json['category']),
      imageUrl: json['image_url'] ?? '',
      readTime: json['read_time'] ?? '5 min read',
    );
  }

  static IconData _mapIconToCategory(String? category) {
    switch (category?.toUpperCase()) {
      case 'HEALTH':
        return LucideIcons.leaf;
      case 'SPIRITUAL':
        return LucideIcons.flame;
      default:
        return LucideIcons.book_open;
    }
  }
}

// 2. API Service Layer
class BlogService {
  static Future<List<BlogPost>> fetchPosts() async {
    // Replace this with: final response = await http.get(Uri.parse('...'));
    await Future.delayed(const Duration(seconds: 1)); // Mock Latency

    final List<Map<String, dynamic>> mockData = [
      {
        'category': 'HEALTH',
        'title': "Vitality: Your Body is God's Temple",
        'subtitle': 'Practical biblical steps to maintaining peak wellness.',
        'image_url':
            'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=800',
        'read_time': '5 min read',
      },
    ];

    return mockData.map((json) => BlogPost.fromJson(json)).toList();
  }
}

class BlogSection extends StatefulWidget {
  final Function(int) onAction;
  const BlogSection({super.key, required this.onAction});

  @override
  State<BlogSection> createState() => _BlogSectionState();
}

class _BlogSectionState extends State<BlogSection> {
  late Future<List<BlogPost>> _blogFuture;
  static const int blogViewIndex = 4;

  @override
  void initState() {
    super.initState();
    _blogFuture = BlogService.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildSectionHeader(),
        const SizedBox(height: 24),
        FutureBuilder<List<BlogPost>>(
          future: _blogFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.orangeAccent));
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const Text("Failed to load blog posts");
            }

            final post =
                snapshot.data![0]; // Displaying the first post for this example
            return _buildElegantCard(context, post);
          },
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
            fontSize: 22, // Reduced to standard mobile H2 size
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
                height: 3,
                width: 32,
                decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 4),
            Container(
                height: 3,
                width: 8,
                decoration: BoxDecoration(
                    color: Colors.orangeAccent.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2))),
          ],
        ),
      ],
    );
  }

  Widget _buildElegantCard(BuildContext context, BlogPost post) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 360),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: AspectRatio(
                  aspectRatio:
                      16 / 10, // More modern cinematic ratio for mobile
                  child: post.imageUrl.startsWith('http')
                      ? Image.network(post.imageUrl, fit: BoxFit.cover)
                      : Image.asset('assets/images/health.jpg',
                          fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: _buildBlurIcon(post.icon),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                post.category,
                style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                    letterSpacing: 1.1),
              ),
              const SizedBox(width: 8),
              const CircleAvatar(radius: 1.5, backgroundColor: Colors.grey),
              const SizedBox(width: 8),
              Text(post.readTime,
                  style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            post.title,
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
                height: 1.25),
          ),
          const SizedBox(height: 6),
          Text(
            post.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 13, color: Color(0xFF64748B), height: 1.5),
          ),
          const SizedBox(height: 12),
          _buildReadMoreButton(),
        ],
      ),
    );
  }

  Widget _buildBlurIcon(IconData icon) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(8),
          color: Colors.white.withOpacity(0.2),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }

  Widget _buildReadMoreButton() {
    return InkWell(
      onTap: () => widget.onAction(blogViewIndex),
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Read More",
              style: TextStyle(
                  color: Color(0xFF0A192F),
                  fontWeight: FontWeight.w800,
                  fontSize: 13)),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: Colors.orangeAccent.withOpacity(0.1),
                shape: BoxShape.circle),
            child: const Icon(LucideIcons.arrow_right,
                size: 12, color: Colors.orangeAccent),
          ),
        ],
      ),
    );
  }
}
