import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class TestimonyView extends StatefulWidget {
  const TestimonyView({super.key});

  @override
  State<TestimonyView> createState() => _TestimonyViewState();
}

class _TestimonyViewState extends State<TestimonyView> {
  // --- UI Logic: Full Testimony Modal ---
  void _showFullTestimony(String name, String content, String time) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(name,
            style: const TextStyle(
                color: Color(0xFF0A192F), fontWeight: FontWeight.bold)),
        content: Text(content,
            style:
                TextStyle(height: 1.6, color: Colors.grey[800], fontSize: 15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text("Close", style: TextStyle(color: Color(0xFF0D47A1))),
          ),
        ],
      ),
    );
  }

  // --- UI Logic: Compact & Modern Submission Sheet ---
  void _showShareTestimonySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85, // Reduced width
          constraints: const BoxConstraints(maxWidth: 400),
          margin: const EdgeInsets.only(bottom: 20), // Float effect
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20)
            ],
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            left: 24,
            right: 24,
            top: 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 20),
              const Text("New Testimony",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0A192F))),
              const SizedBox(height: 24),
              _buildInputField("Name", LucideIcons.user),
              const SizedBox(height: 12),
              _buildInputField("Video URL (Youtube/Vimeo)", LucideIcons.link),
              const SizedBox(height: 12),
              _buildInputField("Your Miracle Story", LucideIcons.pencil,
                  maxLines: 3),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A192F),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text("Post Testimony",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFF),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFF0A192F),
            leading: IconButton(
              icon: const Icon(LucideIcons.arrow_left, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Testimonies",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 25,
                          height: 3,
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 4),
                      Container(
                          width: 10,
                          height: 3,
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(2))),
                    ],
                  )
                ],
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xFF0A192F),
                    Color(0xFF0D47A1),
                    Color(0xFF0A192F)
                  ]),
                ),
                child: Stack(
                  children: [
                    Positioned(
                        right: -20,
                        top: -20,
                        child: Icon(LucideIcons.sparkles,
                            size: 150, color: Colors.white.withOpacity(0.05))),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                      "Featured Miracles", LucideIcons.circle_play),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 240,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildVideoCard("Sarah Williams", "Instant Healing",
                            "https://picsum.photos/400/250"),
                        _buildVideoCard("John Doe", "Financial Open Doors",
                            "https://picsum.photos/401/251"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionHeader(
                      "Written Accounts", LucideIcons.file_text),
                  const SizedBox(height: 16),
                  _buildTextTestimony(
                      "Mercy A.",
                      "God transformed my career after 2 years of unemployment...",
                      "2h ago"),
                  _buildTextTestimony(
                      "Michael T.",
                      "Chronic back pain vanished during the last vigil. I am whole!",
                      "Yesterday"),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showShareTestimonySheet,
        backgroundColor: const Color(0xFF0A192F),
        icon: const Icon(LucideIcons.circle_check, color: Colors.white),
        label: const Text("Share Testimony",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF0D47A1)),
        const SizedBox(width: 10),
        Text(title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0A192F))),
      ],
    );
  }

  Widget _buildInputField(String label, IconData icon, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: label,
        prefixIcon: Icon(icon, size: 18, color: const Color(0xFF0D47A1)),
        filled: true,
        fillColor: const Color(0xFFF8F9FB),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildVideoCard(String name, String title, String imageUrl) {
    return InkWell(
      onTap: () {
        // Logic to launch URL or show video player
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Opening Video Link...")));
      },
      child: Container(
        width: 260,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image:
              DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5))
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.8)]),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(LucideIcons.circle_play,
                  color: Colors.orange, size: 32),
              const SizedBox(height: 8),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              Text(name,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.7), fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextTestimony(String name, String content, String time) {
    return InkWell(
      onTap: () => _showFullTestimony(name, content, time),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(content,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                ],
              ),
            ),
            Text(time,
                style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
