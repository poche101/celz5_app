import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:file_picker/file_picker.dart'; // Add this import

// --- MODELS ---
class Post {
  final String id;
  String title;
  String description;
  String status;
  String date;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.date,
  });
}

class BlogPostTab extends StatefulWidget {
  const BlogPostTab({super.key});

  @override
  State<BlogPostTab> createState() => _BlogPostTabState();
}

class _BlogPostTabState extends State<BlogPostTab> {
  final Color primaryColor = const Color(0xFF6366F1);
  final Color borderColor = const Color(0xFFE2E8F0);

  bool _isLoading = false;
  List<Post> _posts = [];
  List<Map<String, String>> _comments = [];

  // Pagination State
  int _currentPage = 0;
  final int _itemsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _posts = List.generate(
          12,
          (index) => Post(
                id: index.toString(),
                title: "Article #$index: Future of Tech",
                description: "Exploring deep dives into modern architecture.",
                status: index % 2 == 0 ? "Published" : "Draft",
                date: "Jan ${24 - index}",
              ));
      _comments = [
        {"id": "1", "user": "John Doe", "text": "Incredible insights!"}
      ];
      _isLoading = false;
    });
  }

  // --- FILE PICKER LOGIC ---
  Future<void> _pickFile(FileType type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: type);
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selected: ${result.files.first.name}")),
      );
    }
  }

  // --- DELETE CONFIRMATION ---
  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post"),
        content: const Text(
            "Are you sure you want to delete this article? This action cannot be undone."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => _posts.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // --- CENTERED MODAL ---
  void _openPostModal({Post? post, int? index}) {
    final titleController = TextEditingController(text: post?.title ?? "");
    final descController = TextEditingController(text: post?.description ?? "");

    showDialog(
      context: context,
      builder: (context) => Center(
        child: SingleChildScrollView(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              constraints: const BoxConstraints(maxWidth: 550),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post == null ? "Create New Article" : "Edit Article",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: "Article Title",
                      border: const OutlineInputBorder(),
                      prefixIcon: Icon(LucideIcons.type, size: 20),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: descController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: "Description",
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 60),
                        child: Icon(LucideIcons.text_quote, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _mediaButton("Add Photo", LucideIcons.image,
                          () => _pickFile(FileType.image)),
                      const SizedBox(width: 12),
                      _mediaButton("Add Video", LucideIcons.video,
                          () => _pickFile(FileType.video)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel")),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor),
                        onPressed: () {
                          if (titleController.text.isEmpty) return;
                          setState(() {
                            if (index == null) {
                              _posts.insert(
                                  0,
                                  Post(
                                      id: DateTime.now().toString(),
                                      title: titleController.text,
                                      description: descController.text,
                                      status: "Published",
                                      date: "Just now"));
                            } else {
                              _posts[index].title = titleController.text;
                              _posts[index].description = descController.text;
                            }
                          });
                          Navigator.pop(context);
                        },
                        child: const Text("Save Article",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildWelcomeSection(),
          const SizedBox(height: 32),
          _buildMetricsGrid(),
          const SizedBox(height: 32),
          _buildRecentPostsTable(),
          const SizedBox(height: 32),
          _buildCommentSection(),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Blog Management",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          Text("Monitor your article performance.",
              style: TextStyle(color: Color(0xFF64748B), fontSize: 16)),
        ]),
        ElevatedButton.icon(
          onPressed: () => _openPostModal(),
          icon: const Icon(LucideIcons.plus, size: 18, color: Colors.white),
          label: const Text("New Post", style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
        ),
      ],
    );
  }

  Widget _buildRecentPostsTable() {
    final startIndex = _currentPage * _itemsPerPage;
    final paginatedPosts = _posts.skip(startIndex).take(_itemsPerPage).toList();

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor)),
      child: Column(
        children: [
          const Padding(
              padding: EdgeInsets.all(24),
              child: Row(children: [
                Text("Recent Articles",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
              ])),
          const Divider(height: 0),
          ...paginatedPosts
              .asMap()
              .entries
              .map((entry) => _tableRow(entry.value, startIndex + entry.key)),
          _buildPaginationControls(),
        ],
      ),
    );
  }

  Widget _tableRow(Post post, int actualIndex) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      title:
          Text(post.title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle:
          Text(post.description, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _statusChip(post.status),
          const SizedBox(width: 8),
          IconButton(
              icon:
                  const Icon(LucideIcons.pencil, size: 18, color: Colors.blue),
              onPressed: () => _openPostModal(post: post, index: actualIndex)),
          IconButton(
              icon:
                  const Icon(LucideIcons.trash_2, size: 18, color: Colors.red),
              onPressed: () => _confirmDelete(actualIndex)),
        ],
      ),
    );
  }

  Widget _buildPaginationControls() {
    final totalPages = (_posts.length / _itemsPerPage).ceil();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(LucideIcons.chevron_left),
            onPressed:
                _currentPage > 0 ? () => setState(() => _currentPage--) : null,
          ),
          Text("Page ${_currentPage + 1} of $totalPages"),
          IconButton(
            icon: const Icon(LucideIcons.chevron_right),
            onPressed: (_currentPage + 1) < totalPages
                ? () => setState(() => _currentPage++)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _mediaButton(String label, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12)),
      ),
    );
  }

  // Reuse your existing _statusChip, _buildMetricsGrid, _metricCard, _buildCommentSection...
  // (Omitted here for brevity, keep your original implementations)
  Widget _statusChip(String status) {
    bool isPub = status == "Published";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPub
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(status,
          style: TextStyle(
              color: isPub ? Colors.green : Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 12)),
    );
  }

  Widget _buildMetricsGrid() {
    return LayoutBuilder(builder: (context, constraints) {
      int count = constraints.maxWidth > 800 ? 4 : 2;
      return GridView.count(
        crossAxisCount: count,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.5,
        children: [
          _metricCard("Total Views", "128.4k", LucideIcons.eye),
          _metricCard(
              "Total Posts", _posts.length.toString(), LucideIcons.pen_tool),
          _metricCard("Subscribers", "12,840", LucideIcons.user_plus),
          _metricCard("Comments", _comments.length.toString(),
              LucideIcons.message_square),
        ],
      );
    });
  }

  Widget _metricCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: primaryColor, size: 20),
          Text(value,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          Text(title,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCommentSection() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
              padding: EdgeInsets.all(24),
              child: Text("All Comments",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          const Divider(height: 0),
          ..._comments.asMap().entries.map((entry) {
            return ListTile(
              title: Text(entry.value['user']!,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(entry.value['text']!),
              trailing: IconButton(
                icon: const Icon(LucideIcons.trash_2,
                    size: 18, color: Colors.red),
                onPressed: () => setState(() => _comments.removeAt(entry.key)),
              ),
            );
          }),
        ],
      ),
    );
  }
}
