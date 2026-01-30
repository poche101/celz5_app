import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:video_player/video_player.dart';
import 'package:celz5_app/models/testimony_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TestimonyView extends StatefulWidget {
  const TestimonyView({super.key});

  @override
  State<TestimonyView> createState() => _TestimonyViewState();
}

class _TestimonyViewState extends State<TestimonyView> {
  final PageController _videoController =
      PageController(viewportFraction: 0.85);
  final _nameController = TextEditingController();
  final _churchController = TextEditingController();
  final _contentController = TextEditingController();

  bool _isPosting = false;
  late Future<List<TestimonyModel>> _testimoniesFuture;

  @override
  void initState() {
    super.initState();
    _testimoniesFuture = _fetchTestimonies();
  }

  // --- API CALLS ---
  Future<List<TestimonyModel>> _fetchTestimonies() async {
    try {
      final response =
          await http.get(Uri.parse('https://api.example.com/testimonies'));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((t) => TestimonyModel.fromJson(t)).toList();
      }
      throw Exception('Failed to load');
    } catch (e) {
      return _getMockData();
    }
  }

  Future<void> _handlePostTestimony() async {
    if (_nameController.text.isEmpty || _contentController.text.isEmpty) return;
    setState(() => _isPosting = true);

    try {
      final response = await http.post(
        Uri.parse('https://api.example.com/testimonies'),
        body: jsonEncode({
          "full_name": _nameController.text,
          "church": _churchController.text,
          "content": _contentController.text,
        }),
      );

      if (mounted && response.statusCode == 201) {
        Navigator.pop(context);
        _nameController.clear();
        _churchController.clear();
        _contentController.clear();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Testimony shared!")));
        setState(() {
          _testimoniesFuture = _fetchTestimonies();
        });
      }
    } finally {
      if (mounted) setState(() => _isPosting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: FutureBuilder<List<TestimonyModel>>(
        future: _testimoniesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFF0A192F)));
          }

          final testimonies = snapshot.data ?? [];
          final videos = testimonies.where((t) => t.type == 'video').toList();
          final texts = testimonies.where((t) => t.type == 'text').toList();

          return CustomScrollView(
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
                            "Featured Testimonies", LucideIcons.clapperboard),
                        const SizedBox(height: 16),
                        _buildMobileSlider(videos),
                        const SizedBox(height: 32),
                      ],
                      _buildSectionLabel(
                          "Written Accounts", LucideIcons.book_open),
                      _buildWrittenAccounts(texts),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showShareForm,
        backgroundColor: const Color(0xFF0A192F),
        icon: const Icon(LucideIcons.sparkles, color: Colors.white, size: 20),
        label: const Text("Share Yours",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      toolbarHeight: 90,
      backgroundColor: const Color(0xFF0A192F),
      centerTitle: true,
      title: Column(
        children: [
          const Text("TESTIMONIES",
              style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 3,
                  fontSize: 18,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 45,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 6),
              Container(
                  width: 15,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(2))),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.orange),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0A192F))),
        ],
      ),
    );
  }

  Widget _buildMobileSlider(List<TestimonyModel> videos) {
    return SizedBox(
      height: 300,
      child: PageView.builder(
        controller: _videoController,
        itemCount: videos.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => _openDetail(videos[index]),
          child: _buildVideoCard(videos[index]),
        ),
      ),
    );
  }

  Widget _buildVideoCard(TestimonyModel t) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        image: DecorationImage(
            image: NetworkImage(t.thumbnailUrl ?? ''), fit: BoxFit.cover),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.85)]),
        ),
        child: Stack(
          children: [
            const Center(
                child: Icon(LucideIcons.circle_play,
                    color: Colors.orange, size: 54)),
            Positioned(
              bottom: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.fullName,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 250,
                    child: Text(t.content,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWrittenAccounts(List<TestimonyModel> tests) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: tests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.grey.shade200)),
        child: ListTile(
          onTap: () => _openDetail(tests[index]),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          title: Text(tests[index].fullName,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A192F))),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(tests[index].content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14, color: Colors.grey[600], height: 1.4)),
          ),
          trailing: const Icon(LucideIcons.chevron_right,
              size: 18, color: Colors.orange),
        ),
      ),
    );
  }

  void _openDetail(TestimonyModel t) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: _TestimonyDetailModal(testimony: t),
        ),
      ),
    );
  }

  void _showShareForm() {
    showDialog(
      context: context,
      barrierDismissible: !_isPosting,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Share Your Testimony",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A192F))),
                    const SizedBox(height: 24),
                    _dialogField(_nameController, "Full Name", LucideIcons.user,
                        !_isPosting),
                    const SizedBox(height: 16),
                    _dialogField(_churchController, "Church / Group",
                        LucideIcons.church, !_isPosting),
                    const SizedBox(height: 16),
                    _dialogField(_contentController, "Describe what God did...",
                        LucideIcons.pen_line, !_isPosting,
                        maxLines: 4),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A192F),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16))),
                        onPressed: _isPosting
                            ? null
                            : () async {
                                setDialogState(() => _isPosting = true);
                                await _handlePostTestimony();
                                if (mounted)
                                  setDialogState(() => _isPosting = false);
                              },
                        child: _isPosting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
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
                        onPressed:
                            _isPosting ? null : () => Navigator.pop(context),
                        child: const Text("Maybe later",
                            style: TextStyle(color: Colors.grey))),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dialogField(
      TextEditingController ctrl, String hint, IconData icon, bool enabled,
      {int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      enabled: enabled,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 20, color: Colors.orange),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200)),
      ),
    );
  }

  List<TestimonyModel> _getMockData() {
    return [
      TestimonyModel(
          id: '1',
          type: 'video',
          fullName: 'Sister Sarah Johnson',
          content:
              'Healed from 5 years of chronic back pain during the service.',
          thumbnailUrl:
              'https://images.unsplash.com/photo-1510531704581-5b2870972060?w=600',
          videoUrl:
              'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
      TestimonyModel(
          id: '2',
          type: 'video',
          fullName: 'Brother David Okoro',
          content: 'Supernatural debt cancellation and a new job offer.',
          thumbnailUrl:
              'https://images.unsplash.com/photo-1523580494863-6f3031224c94?w=600',
          videoUrl:
              'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'),
      TestimonyModel(
          id: '3',
          type: 'text',
          fullName: 'Blessing Amen',
          content:
              'I want to thank God for the safe delivery of my twin babies. The doctors said there would be complications, but God proved them wrong!'),
      TestimonyModel(
          id: '4',
          type: 'text',
          fullName: 'John Mark',
          content:
              'God provided the exact tuition fees for my final year when all hope was lost. Truly, He is a provider.'),
      TestimonyModel(
          id: '5',
          type: 'text',
          fullName: 'Esther Williams',
          content:
              'My mother was discharged from the hospital after 3 months. The doctors called it a miracle.'),
      TestimonyModel(
          id: '6',
          type: 'text',
          fullName: 'Samuel Peterson',
          content:
              'Promoted to Senior Manager after just 6 months at the new firm! Glory to God.'),
    ];
  }
}

class _TestimonyDetailModal extends StatefulWidget {
  final TestimonyModel testimony;
  const _TestimonyDetailModal({required this.testimony});

  @override
  State<_TestimonyDetailModal> createState() => _TestimonyDetailModalState();
}

class _TestimonyDetailModalState extends State<_TestimonyDetailModal> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.testimony.type == 'video' && widget.testimony.videoUrl != null) {
      _controller = VideoPlayerController.networkUrl(
          Uri.parse(widget.testimony.videoUrl!))
        ..initialize().then((_) => setState(() {}));
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                  backgroundColor: Colors.orange.withOpacity(0.1),
                  child: const Icon(LucideIcons.quote,
                      color: Colors.orange, size: 18)),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(widget.testimony.fullName,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0A192F)))),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(LucideIcons.x, size: 20))
            ],
          ),
          const SizedBox(height: 20),
          if (widget.testimony.type == 'video' && _controller != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: _controller!.value.isInitialized
                    ? _controller!.value.aspectRatio
                    : 16 / 9,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_controller!.value.isInitialized)
                      VideoPlayer(_controller!)
                    else
                      const Center(child: CircularProgressIndicator()),
                    IconButton(
                      icon: Icon(
                          _controller!.value.isPlaying
                              ? LucideIcons.circle_pause
                              : LucideIcons.circle_play,
                          color: Colors.white,
                          size: 64),
                      onPressed: () => setState(() =>
                          _controller!.value.isPlaying
                              ? _controller!.pause()
                              : _controller!.play()),
                    )
                  ],
                ),
              ),
            ),
          const SizedBox(height: 20),
          const Text("THE TESTIMONY",
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: Colors.orange,
                  letterSpacing: 1)),
          const SizedBox(height: 8),
          Flexible(
            child: SingleChildScrollView(
              child: Text(widget.testimony.content,
                  style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.grey[800],
                      fontStyle: FontStyle.italic)),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A192F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: () => Navigator.pop(context),
              child: const Text("Praise God",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
