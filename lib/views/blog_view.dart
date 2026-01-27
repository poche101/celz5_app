import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class BlogView extends StatefulWidget {
  const BlogView({super.key});

  @override
  State<BlogView> createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  final Color primaryColor = const Color(0xFF6366F1);
  final Color scaffoldBg = const Color(0xFFF8FAFC);
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // Standard desktop breakpoint
    bool isWide = width > 900;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSleekNavBar(),
          // 1. TOP BANNER
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? width * 0.05 : 20,
                vertical: 24,
              ),
              child: _buildFeaturedBanner(isWide),
            ),
          ),
          // 2. MAIN CONTENT
          SliverPadding(
            padding:
                EdgeInsets.symmetric(horizontal: isWide ? width * 0.05 : 20),
            sliver: SliverToBoxAdapter(
              child: isWide ? _buildTwoColumnLayout() : _buildMobileLayout(),
            ),
          ),
          // 3. PAGINATION
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 80),
              child: _buildPagination(),
            ),
          ),
        ],
      ),
    );
  }

  // --- MOBILE LAYOUT (Now includes categories) ---
  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchBar(),
        const SizedBox(height: 32),
        _buildCategoryList(), // Added to mobile
        const SizedBox(height: 40),
        const Text("LATEST STORIES",
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 12,
                letterSpacing: 1,
                color: Color(0xFF1E293B))),
        const SizedBox(height: 20),
        _buildBlogCard(
            title: "Finding Peace in a Busy Modern World",
            desc:
                "In an era of constant notifications and digital noise, discovering the discipline of silence..."),
        _buildBlogCard(
            title: "The Power of Community Gardening",
            desc:
                "How planting seeds together in the physical world mirrors our growth in the spiritual realm..."),
        const SizedBox(height: 20),
        _buildNewsletterSignup(), // Added to mobile
      ],
    );
  }

  // --- DESKTOP TWO-COLUMN LAYOUT ---
  Widget _buildTwoColumnLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 7,
          child: Column(
            children: [
              _buildBlogCard(
                  title: "Finding Peace in a Busy Modern World",
                  desc:
                      "In an era of constant notifications and digital noise, discovering the discipline of silence is no longer a luxury—it's a necessity for spiritual survival..."),
              _buildBlogCard(
                  title: "The Power of Community Gardening",
                  desc:
                      "How planting seeds together in the physical world mirrors our growth in the spiritual realm. Explore the latest initiatives in our local community garden..."),
              _buildBlogCard(
                  title: "Leadership in the New Decade",
                  desc:
                      "Authentic leadership is shifting from top-down authority to humble service. Here are the three pillars of modern servant leadership we are adopting..."),
            ],
          ),
        ),
        const SizedBox(width: 48),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              const SizedBox(height: 40),
              _buildCategoryList(),
              const SizedBox(height: 40),
              _buildNewsletterSignup(),
            ],
          ),
        ),
      ],
    );
  }

  // --- MODAL READER ---
  void _showFullArticle(String title, String desc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2))),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(32),
                children: [
                  _tag("READING MODE"),
                  const SizedBox(height: 16),
                  Text(title,
                      style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          height: 1.2)),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),
                  Text(
                      "$desc\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Sed efficitur, leo non interdum finibus, tellus nisl sodales lorem, at feugiat magna tellus nec nisl.",
                      style: const TextStyle(
                          fontSize: 18, height: 1.8, color: Color(0xFF334155))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI COMPONENTS (UNCHANGED STYLING) ---
  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        int pageNum = index + 1;
        bool isSelected = _currentPage == pageNum;
        return GestureDetector(
          onTap: () => setState(() => _currentPage = pageNum),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: isSelected ? primaryColor : const Color(0xFFE2E8F0)),
            ),
            alignment: Alignment.center,
            child: Text("$pageNum",
                style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
                    fontWeight: FontWeight.bold)),
          ),
        );
      }),
    );
  }

  Widget _buildFeaturedBanner(bool isWide) {
    return Container(
      height: isWide ? 400 : 350,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: const DecorationImage(
              image: NetworkImage(
                  'https://images.unsplash.com/photo-1493612276216-ee3925520721?q=80&w=1000'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken))),
      child: Padding(
        padding: EdgeInsets.all(isWide ? 60.0 : 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _tag("EDITORIAL FEATURE"),
            const SizedBox(height: 16),
            Text("How Modern Technology is Reshaping\nOur Spiritual Connection",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: isWide ? 42 : 28,
                    fontWeight: FontWeight.w900,
                    height: 1.1)),
            const SizedBox(height: 12),
            const Text("By Dr. Elena Vance • January 2026",
                style: TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildBlogCard({required String title, required String desc}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 240,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              image: DecorationImage(
                  image: NetworkImage(
                      'https://images.unsplash.com/photo-1499750310107-5fef28a66643?q=80&w=1000'),
                  fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  _tag("NEW STORY"),
                  const SizedBox(width: 12),
                  const Text("5 min read",
                      style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 12,
                          fontWeight: FontWeight.w600))
                ]),
                const SizedBox(height: 16),
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        color: Color(0xFF0F172A))),
                const SizedBox(height: 12),
                Text(desc,
                    style: const TextStyle(
                        color: Color(0xFF64748B), fontSize: 15, height: 1.6)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    TextButton(
                        onPressed: () => _showFullArticle(title, desc),
                        child: Text("Read Full Story",
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w800))),
                    Icon(LucideIcons.arrow_right,
                        size: 16, color: primaryColor),
                    const Spacer(),
                    _iconStat(LucideIcons.heart, "42"),
                    const SizedBox(width: 16),
                    _iconStat(LucideIcons.message_circle, "12"),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0))),
        child: const TextField(
            decoration: InputDecoration(
                hintText: "Search articles...",
                hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                prefixIcon: Icon(LucideIcons.search,
                    size: 18, color: Color(0xFF64748B)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15))),
      );

  Widget _buildCategoryList() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("CATEGORIES",
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 12,
                letterSpacing: 1,
                color: Color(0xFF1E293B))),
        const SizedBox(height: 20),
        Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              "Spirituality",
              "Mental Health",
              "Leadership",
              "Technology",
              "Events",
              "Culture"
            ]
                .map((c) => ActionChip(
                    label: Text(c),
                    onPressed: () {},
                    backgroundColor: Colors.white,
                    labelStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF475569)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Color(0xFFE2E8F0)))))
                .toList()),
      ]);

  Widget _buildNewsletterSignup() => Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryColor.withOpacity(0.1))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Keep in touch",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        const SizedBox(height: 8),
        const Text("Join our newsletter for weekly insights.",
            style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
        const SizedBox(height: 20),
        ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0),
            child: const Text("Subscribe",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)))
      ]));

  Widget _buildSleekNavBar() => SliverAppBar(
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white.withOpacity(0.9),
      title: const Text("CELZ5 Blog",
          style: TextStyle(
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w900,
              letterSpacing: 2)),
      centerTitle: false);

  Widget _tag(String label) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: primaryColor, borderRadius: BorderRadius.circular(6)),
      child: Text(label,
          style: const TextStyle(
              color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)));

  Widget _iconStat(IconData icon, String label) => Row(children: [
        Icon(icon, size: 16, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w600))
      ]);
}
