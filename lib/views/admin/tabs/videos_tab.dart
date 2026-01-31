import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

class VideoTab extends StatefulWidget {
  const VideoTab({super.key});

  @override
  State<VideoTab> createState() => _VideoTabState();
}

class _VideoTabState extends State<VideoTab> {
  // --- THEME CONSTANTS ---
  final Color primaryBrand = const Color(0xFF6366F1);
  final Color surfaceColor = const Color(0xFFF8FAFC);
  final Color cardColor = Colors.white;
  final Color textPrimary = const Color(0xFF1E293B);
  final Color textSecondary = const Color(0xFF64748B);
  final Color borderSubtle = const Color(0xFFE2E8F0);

  // --- DATA & STATE ---
  bool _isLoading = false;
  List<Map<String, dynamic>> _videoArchive = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // --- PAGINATION STATE ---
  int _currentPage = 1;
  int _rowsPerPage = 5;
  final List<int> _availableRowsPerPage = [5, 10, 25, 50];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _videoArchive = List.generate(
        24,
        (index) => {
          "id": index + 1,
          "title": index % 2 == 0
              ? "The Power of Meditation Vol. ${index + 1}"
              : "Walking in Wisdom Ep. ${index + 1}",
          "episode": (index + 1).toString().padLeft(2, '0'),
          "date": "2024-01-${(index % 28) + 1}",
          "videoUrl": "https://example.com/video_stream_${index + 1}.mp4",
          "posterPath":
              "https://images.unsplash.com/photo-1506126613408-eca07ce68773?q=80&w=200",
        },
      );
      _isLoading = false;
    });
  }

  // --- LOGIC: FILTERING & PAGINATION ---

  List<Map<String, dynamic>> get _filteredVideos {
    if (_searchQuery.isEmpty) return _videoArchive;
    return _videoArchive.where((video) {
      final title = video['title'].toString().toLowerCase();
      final ep = video['episode'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return title.contains(query) || ep.contains(query);
    }).toList();
  }

  List<Map<String, dynamic>> get _paginatedVideos {
    final filtered = _filteredVideos;
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    final endIndex = startIndex + _rowsPerPage;
    if (startIndex >= filtered.length) return [];
    return filtered.sublist(
      startIndex,
      endIndex > filtered.length ? filtered.length : endIndex,
    );
  }

  int get _totalPages =>
      (_filteredVideos.length / _rowsPerPage).ceil().clamp(1, 999);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: surfaceColor,
      child: _isLoading
          ? Center(child: CircularProgressIndicator(color: primaryBrand))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildStatsRow(),
                  const SizedBox(height: 32),
                  _buildTableContainer(),
                ],
              ),
            ),
    );
  }

  // --- UI SECTIONS ---

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Video Archive",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                    letterSpacing: -0.5)),
            Text("Search and manage your library of recordings.",
                style: TextStyle(color: textSecondary, fontSize: 15)),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showVideoModal(),
          icon: const Icon(LucideIcons.clapperboard,
              size: 18, color: Colors.white),
          label: const Text("Post New Video",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBrand,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _statItem("Total Matches", _filteredVideos.length.toString(),
            LucideIcons.video, Colors.blue),
        const SizedBox(width: 20),
        _statItem(
            "Storage Used", "1.2 TB", LucideIcons.hard_drive, Colors.orange),
        const SizedBox(width: 20),
        _statItem("Total Views", "45.8k", LucideIcons.eye, Colors.green),
      ],
    );
  }

  Widget _buildTableContainer() {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderSubtle),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSearchHeader(), // Search bar added here
          const Divider(height: 1),
          _buildVideoTable(),
          _buildPaginationFooter(),
        ],
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          const Text("Recent Uploads",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          SizedBox(
            width: 300,
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() {
                _searchQuery = value;
                _currentPage = 1; // Reset to page 1 on search
              }),
              decoration: InputDecoration(
                hintText: "Search title or episode...",
                prefixIcon: const Icon(LucideIcons.search, size: 18),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(LucideIcons.x, size: 16),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = "";
                            _currentPage = 1;
                          });
                        },
                      )
                    : null,
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: borderSubtle),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoTable() {
    final videos = _paginatedVideos;
    if (videos.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(child: Text("No recordings match your search.")),
      );
    }

    return DataTable(
      headingRowColor: WidgetStateProperty.all(surfaceColor),
      horizontalMargin: 24,
      columnSpacing: 24,
      columns: const [
        DataColumn(label: Text("CONTENT")),
        DataColumn(label: Text("EPISODE")),
        DataColumn(label: Text("PUBLISHED DATE")),
        DataColumn(label: Text("ACTIONS")),
      ],
      rows: videos.map((video) {
        return DataRow(cells: [
          DataCell(Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(video['posterPath'],
                    width: 48,
                    height: 32,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: borderSubtle, width: 48, height: 32)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(video['title'],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis),
                    Text(video['videoUrl'],
                        style: TextStyle(fontSize: 11, color: textSecondary),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          )),
          DataCell(Text("Ep. ${video['episode']}")),
          DataCell(Text(video['date'])),
          DataCell(Row(
            children: [
              IconButton(
                icon: const Icon(LucideIcons.pencil,
                    size: 18, color: Colors.blueGrey),
                onPressed: () => _showVideoModal(video: video),
              ),
              IconButton(
                icon: const Icon(LucideIcons.trash_2,
                    size: 18, color: Colors.redAccent),
                onPressed: () => _confirmDelete(video['id']),
              ),
            ],
          )),
        ]);
      }).toList(),
    );
  }

  Widget _buildPaginationFooter() {
    final filteredCount = _filteredVideos.length;
    final int startRange =
        filteredCount == 0 ? 0 : ((_currentPage - 1) * _rowsPerPage) + 1;
    final int endRange = (_currentPage * _rowsPerPage) > filteredCount
        ? filteredCount
        : (_currentPage * _rowsPerPage);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration:
          BoxDecoration(border: Border(top: BorderSide(color: borderSubtle))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Showing $startRange to $endRange of $filteredCount results",
              style: TextStyle(color: textSecondary, fontSize: 14)),
          Row(
            children: [
              Text("Rows:",
                  style: TextStyle(color: textSecondary, fontSize: 14)),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: _rowsPerPage,
                underline: const SizedBox(),
                items: _availableRowsPerPage
                    .map((val) =>
                        DropdownMenuItem(value: val, child: Text("$val")))
                    .toList(),
                onChanged: (val) => setState(() {
                  _rowsPerPage = val!;
                  _currentPage = 1;
                }),
              ),
              const SizedBox(width: 24),
              _buildPageAction(
                  LucideIcons.chevron_left,
                  _currentPage > 1
                      ? () => setState(() => _currentPage--)
                      : null),
              const SizedBox(width: 12),
              Text("$_currentPage / $_totalPages",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              _buildPageAction(
                  LucideIcons.chevron_right,
                  _currentPage < _totalPages
                      ? () => setState(() => _currentPage++)
                      : null),
            ],
          ),
        ],
      ),
    );
  }

  // --- REUSABLE WIDGETS & MODALS (Remaining Code Stays Identical to Previous) ---

  Widget _buildPageAction(IconData icon, VoidCallback? onTap) {
    bool isDisabled = onTap == null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: borderSubtle),
          borderRadius: BorderRadius.circular(8),
          color: isDisabled ? surfaceColor : Colors.white,
        ),
        child:
            Icon(icon, size: 18, color: isDisabled ? Colors.grey : textPrimary),
      ),
    );
  }

  void _showVideoModal({Map<String, dynamic>? video}) {
    final titleCtrl = TextEditingController(text: video?['title'] ?? "");
    final epCtrl = TextEditingController(text: video?['episode'] ?? "");
    final linkCtrl = TextEditingController(text: video?['videoUrl'] ?? "");
    final dateCtrl = TextEditingController(
        text:
            video?['date'] ?? DateFormat('yyyy-MM-dd').format(DateTime.now()));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(video == null ? "Post New Video" : "Edit Video Info"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildField(titleCtrl, "Video Title", LucideIcons.heading),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                      child: _buildField(
                          epCtrl, "Episode Number", LucideIcons.hash)),
                  const SizedBox(width: 16),
                  Expanded(
                      child: _buildField(
                          dateCtrl, "Release Date", LucideIcons.calendar)),
                ],
              ),
              const SizedBox(height: 16),
              _buildField(linkCtrl, "Video Streaming Link", LucideIcons.link),
              const SizedBox(height: 24),
              _buildUploadPlaceholder(),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryBrand),
            onPressed: () => Navigator.pop(context),
            child: const Text("Save Content",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Video?"),
        content: const Text(
            "This recording will be permanently removed from the archive."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                setState(() => _videoArchive.removeWhere((v) => v['id'] == id));
                Navigator.pop(context);
              },
              child:
                  const Text("Delete", style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderSubtle),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                Text(label,
                    style: TextStyle(color: textSecondary, fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String label, IconData icon) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildUploadPlaceholder() {
    return GestureDetector(
      onTap: () async =>
          await FilePicker.platform.pickFiles(type: FileType.image),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderSubtle, style: BorderStyle.solid),
        ),
        child: Column(
          children: [
            Icon(LucideIcons.image_plus, color: primaryBrand, size: 32),
            const SizedBox(height: 8),
            const Text("Upload Thumbnail",
                style: TextStyle(fontWeight: FontWeight.w600)),
            Text("JPEG or PNG up to 2MB",
                style: TextStyle(color: textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
