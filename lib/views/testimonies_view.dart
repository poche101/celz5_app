import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/testimony_model.dart';
import '../services/testimony_service.dart';
import '../utils/toast_util.dart';
import 'package:celz5_app/views/shared/footer.dart';

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

  late Future<List<Testimony>> _testimonyFuture;
  final Set<int> _playingIndices = {};
  String? _token;
  bool _isPosting = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _testimonyFuture = TestimonyService(authToken: _token).fetchTestimonies();
    });
  }

  Future<void> _handlePostTestimony() async {
    if (_nameController.text.isEmpty || _contentController.text.isEmpty) {
      ToastUtil.show(
          context: context,
          message: "Please fill in all required fields",
          isError: true);
      return;
    }

    setState(() => _isPosting = true);

    try {
      final service = TestimonyService(authToken: _token);
      final result = await service.submitTestimony(
        name: _nameController.text,
        group: _churchController.text,
        content: _contentController.text,
      );

      if (!mounted) return;

      if (result['status'] == 'success') {
        Navigator.pop(context);
        _nameController.clear();
        _churchController.clear();
        _contentController.clear();
        _refreshData();
        ToastUtil.show(
            context: context,
            message:
                result['message'] ?? "Testimony shared! Pending approval.");
      } else if (result['status'] == 'profile_incomplete') {
        Navigator.pop(context);
        _showProfileWarning(result['message']);
      } else {
        ToastUtil.show(
            context: context,
            message: result['message'] ?? "An error occurred",
            isError: true);
      }
    } finally {
      if (mounted) setState(() => _isPosting = false);
    }
  }

  void _showProfileWarning(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Icon(LucideIcons.user_round_pen, color: Colors.orange),
            SizedBox(width: 10),
            Text("Update Profile"),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text("Maybe Later", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1)),
            onPressed: () {
              Navigator.pop(context);
              // Add Navigation logic to Profile here
            },
            child: const Text("Go to Profile",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFF),
      body: FutureBuilder<List<Testimony>>(
        future: _testimonyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) return _buildErrorState();

          final allData = snapshot.data ?? [];
          if (allData.isEmpty) return _buildEmptyState();

          final videos = allData.where((t) => t.type == 'video').toList();
          final textTests = allData.where((t) => t.type == 'text').toList();

          return RefreshIndicator(
            onRefresh: () async => _refreshData(),
            child: CustomScrollView(
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
                        _buildSectionLabel(
                            "Written Accounts", LucideIcons.book_open),
                        _buildWrittenAccounts(textTests),
                        const SizedBox(height: 40),
                        const CelzFooter(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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
      iconTheme: const IconThemeData(color: Colors.white),
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

  Widget _buildMobileSlider(List<Testimony> videos) {
    return SizedBox(
      height: 260,
      child: PageView.builder(
        controller: _videoController,
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final t = videos[index];
          return _buildVideoCard(index, t.fullName, t.content,
              t.thumbnailUrl ?? "https://picsum.photos/400/250");
        },
      ),
    );
  }

  Widget _buildVideoCard(int index, String name, String title, String img) {
    bool isPlaying = _playingIndices.contains(index);
    return GestureDetector(
      onTap: () => setState(() {
        _playingIndices.clear();
        if (!isPlaying) _playingIndices.add(index);
      }),
      child: Container(
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
          child: Center(
              child: Icon(
                  isPlaying
                      ? LucideIcons.circle_pause
                      : LucideIcons.circle_play,
                  color: Colors.orange,
                  size: 50)),
        ),
      ),
    );
  }

  Widget _buildWrittenAccounts(List<Testimony> tests) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: tests.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildTextItem(tests[index]),
    );
  }

  Widget _buildTextItem(Testimony t) {
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
        title: Text(t.fullName,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF0A192F))),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(t.content,
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
                            : () async {
                                setModalState(() => _isPosting = true);
                                await _handlePostTestimony();
                                if (mounted)
                                  setModalState(() => _isPosting = false);
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.message_square_dashed,
              size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("No testimonies yet.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          TextButton(
              onPressed: _refreshData, child: const Text("Tap to Refresh")),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.wifi_off, size: 48, color: Colors.redAccent),
          const SizedBox(height: 16),
          const Text("Unable to connect",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _refreshData, child: const Text("Retry")),
        ],
      ),
    );
  }
}
