import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:video_player/video_player.dart';

class TestimonyView extends StatefulWidget {
  const TestimonyView({super.key});

  @override
  State<TestimonyView> createState() => _TestimonyViewState();
}

class _TestimonyViewState extends State<TestimonyView> {
  final PageController _videoController =
      PageController(viewportFraction: 0.85);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _churchController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool _isPosting = false;

  // Updated Mock Data with video URLs
  final List<Map<String, String>> _mockTestimonies = [
    {
      "type": "video",
      "fullName": "Sister Sarah Johnson",
      "content": "Healed from chronic back pain after the night of bliss.",
      "thumbnailUrl":
          "https://images.unsplash.com/photo-1510531704581-5b2870972060?q=80&w=800",
      "videoUrl":
          "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"
    },
    {
      "type": "video",
      "fullName": "Brother David Okoro",
      "content": "Received a major promotion at work.",
      "thumbnailUrl":
          "https://images.unsplash.com/photo-1523580494863-6f3031224c94?q=80&w=800",
      "videoUrl":
          "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4"
    },
    {
      "type": "text",
      "fullName": "Blessing Amen",
      "content":
          "I want to thank God for safe delivery of my twin babies. The doctors said there would be complications, but God proved them wrong!"
    },
    {
      "type": "text",
      "fullName": "John Mark",
      "content":
          "God provided the tuition fees for my final year when all hope was lost. Truly, He is a provider."
    },
  ];

  void _handlePostTestimony() {
    if (_nameController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields")),
      );
      return;
    }

    setState(() => _isPosting = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isPosting = false);
      Navigator.pop(context);
      _nameController.clear();
      _churchController.clear();
      _contentController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Testimony shared locally!")),
      );
    });
  }

  // Opens the Full Testimony in a Modal
  void _openTestimonyDetail(Map<String, String> testimony) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TestimonyDetailModal(testimony: testimony),
    );
  }

  @override
  Widget build(BuildContext context) {
    final videos = _mockTestimonies.where((t) => t['type'] == 'video').toList();
    final textTests =
        _mockTestimonies.where((t) => t['type'] == 'text').toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFF),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (videos.isNotEmpty) ...[
                    _buildSectionLabel(
                        "Featured Miracles", LucideIcons.circle_play),
                    const SizedBox(height: 16),
                    _buildMobileSlider(videos),
                    const SizedBox(height: 40),
                  ],
                  _buildSectionLabel("Written Accounts", LucideIcons.book_open),
                  _buildWrittenAccounts(textTests),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showShareForm,
        backgroundColor: const Color(0xFF0A192F),
        icon: const Icon(LucideIcons.sparkles, color: Colors.white, size: 20),
        label: const Text("Share Testimony",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      backgroundColor: const Color(0xFF0A192F),
      // BACK ARROW FIX: Explicitly ensuring navigation to 'views/home_view'
      leading: IconButton(
        icon: const Icon(LucideIcons.arrow_left, color: Colors.white),
        onPressed: () {
          Navigator.pushReplacementNamed(context, 'views/home_view');
        },
      ),
      centerTitle: true,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("TESTIMONIES",
              style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2,
                  fontSize: 14,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 45,
                  height: 3,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 6),
              Container(
                  width: 15,
                  height: 3,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(2))),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMobileSlider(List<Map<String, String>> videos) {
    return SizedBox(
      height: 260,
      child: PageView.builder(
        controller: _videoController,
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final t = videos[index];
          return GestureDetector(
            onTap: () => _openTestimonyDetail(t),
            child: _buildVideoCard(
                t['fullName']!, t['content']!, t['thumbnailUrl']!),
          );
        },
      ),
    );
  }

  Widget _buildVideoCard(String name, String title, String img) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        image: DecorationImage(image: NetworkImage(img), fit: BoxFit.cover),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black87]),
        ),
        child: Stack(
          children: [
            const Center(
                child: Icon(LucideIcons.circle_play,
                    color: Colors.orange, size: 50)),
            Positioned(
              bottom: 0,
              left: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(title,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12),
                      maxLines: 1),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWrittenAccounts(List<Map<String, String>> tests) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: tests.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => _openTestimonyDetail(tests[index]),
        child: _buildTextItem(tests[index]),
      ),
    );
  }

  Widget _buildTextItem(Map<String, String> t) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(t['fullName']!,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF0A192F))),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(t['content']!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[600])),
        ),
        trailing:
            const Icon(LucideIcons.chevron_right, size: 18, color: Colors.grey),
      ),
    );
  }

  Widget _buildSectionLabel(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF0D47A1)),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0A192F))),
        ],
      ),
    );
  }

  void _showShareForm() {
    showDialog(
      context: context,
      barrierDismissible: !_isPosting,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Center(
          child: SingleChildScrollView(
            child: Dialog(
              backgroundColor: Colors.white,
              insetPadding: const EdgeInsets.symmetric(horizontal: 24),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28)),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0F7FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.sparkles,
                          color: Color(0xFF0D47A1), size: 28),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Share Your Miracle",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0A192F),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _modalTextField(
                        _nameController, "Full Name", LucideIcons.user),
                    const SizedBox(height: 16),
                    _modalTextField(_churchController, "Church / Fellowship",
                        LucideIcons.church),
                    const SizedBox(height: 16),
                    _modalTextField(
                      _contentController,
                      "Describe what God did...",
                      LucideIcons.pen_tool,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isPosting
                            ? null
                            : () {
                                setModalState(() => _isPosting = true);
                                _handlePostTestimony();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A192F),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: _isPosting
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : const Text("Post Testimony",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel",
                          style: TextStyle(color: Colors.grey[500])),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _modalTextField(
      TextEditingController controller, String hint, IconData icon,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 18, color: const Color(0xFF0D47A1)),
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF8F9FB),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none),
      ),
    );
  }
}

// Separate Widget for the Testimony Detail Modal
class _TestimonyDetailModal extends StatefulWidget {
  final Map<String, String> testimony;
  const _TestimonyDetailModal({required this.testimony});

  @override
  State<_TestimonyDetailModal> createState() => _TestimonyDetailModalState();
}

class _TestimonyDetailModalState extends State<_TestimonyDetailModal> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.testimony['type'] == 'video') {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.testimony['videoUrl']!),
      )..initialize().then((_) {
          setState(() {}); // Show first frame
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2)),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFFF0F7FF),
                        child: Text(widget.testimony['fullName']![0],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0D47A1))),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        widget.testimony['fullName']!,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A192F)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (widget.testimony['type'] == 'video') ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: AspectRatio(
                        aspectRatio: _controller?.value.aspectRatio ?? 16 / 9,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (_controller != null &&
                                _controller!.value.isInitialized)
                              VideoPlayer(_controller!)
                            else
                              const CircularProgressIndicator(),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _controller!.value.isPlaying
                                      ? _controller!.pause()
                                      : _controller!.play();
                                });
                              },
                              child: Icon(
                                _controller?.value.isPlaying ?? false
                                    ? LucideIcons.circle_pause
                                    : LucideIcons.circle_play,
                                size: 64,
                                color: Colors.orange.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    VideoProgressIndicator(_controller!, allowScrubbing: true),
                  ],
                  const SizedBox(height: 20),
                  const Text(
                    "Testimony Details",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.testimony['content']!,
                    style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.grey[800],
                        fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Done",
                          style: TextStyle(
                              color: Color(0xFF0A192F),
                              fontWeight: FontWeight.bold)),
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
