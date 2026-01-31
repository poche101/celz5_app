import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:file_picker/file_picker.dart';

class TestimoniesTab extends StatefulWidget {
  const TestimoniesTab({super.key});

  @override
  State<TestimoniesTab> createState() => _TestimonyTabState();
}

class _TestimonyTabState extends State<TestimoniesTab> {
  final Color primaryColor = const Color(0xFF0A192F);
  final Color borderColor = const Color(0xFFE2E8F0);

  bool _isLoading = false;
  List<Map<String, dynamic>> _testimonies = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _testimonies = [
          {
            "id": "1",
            "name": "Sarah Johnson",
            "type": "video",
            "content": "Healed from chronic pain",
            "status": "Approved",
            "date": "Jan 28, 2024"
          },
          {
            "id": "2",
            "name": "David Okoro",
            "type": "text",
            "content": "Financial breakthrough...",
            "status": "Pending",
            "date": "Jan 29, 2024"
          },
        ];
        _isLoading = false;
      });
    }
  }

  // --- UI BUILDING BLOCKS ---

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Removed Scaffold here to prevent nested scaffold issues
    return Container(
      color: const Color(0xFFF9FAFB),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildStatsGrid(),
            const SizedBox(height: 32),
            _buildTableContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Testimony Management",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            Text("Review and publish testimonies.",
                style: TextStyle(color: Color(0xFF64748B))),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _openTestimonyModal(),
          icon: const Icon(LucideIcons.plus, size: 18, color: Colors.white),
          label: const Text("Add Testimony",
              style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    int videoCount = _testimonies.where((t) => t['type'] == 'video').length;
    return Row(
      children: [
        _statCard("Total Submissions", _testimonies.length.toString(),
            LucideIcons.database, Colors.blue),
        const SizedBox(width: 20),
        _statCard("Video Testimonies", videoCount.toString(), LucideIcons.play,
            Colors.purple),
      ],
    );
  }

  Widget _buildTableContainer() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text("Recent Submissions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const Divider(height: 1),
          // Scrollable table to prevent layout overflow
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              horizontalMargin: 20,
              columnSpacing: 40,
              columns: const [
                DataColumn(label: Text("NAME")),
                DataColumn(label: Text("TYPE")),
                DataColumn(label: Text("CONTENT")),
                DataColumn(label: Text("STATUS")),
                DataColumn(label: Text("ACTIONS")),
              ],
              rows: _testimonies.asMap().entries.map((entry) {
                int index = entry.key;
                var data = entry.value;
                return DataRow(cells: [
                  DataCell(Text(data['name'],
                      style: const TextStyle(fontWeight: FontWeight.w500))),
                  DataCell(_typeBadge(data['type'])),
                  DataCell(SizedBox(
                      width: 200,
                      child: Text(data['content'],
                          overflow: TextOverflow.ellipsis))),
                  DataCell(_statusChip(data['status'])),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: const Icon(LucideIcons.pencil,
                            size: 18, color: Colors.blue),
                        onPressed: () =>
                            _openTestimonyModal(data: data, index: index),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.trash_2,
                            size: 18, color: Colors.red),
                        onPressed: () => _confirmDelete(index),
                      ),
                    ],
                  )),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPERS & MODALS ---

  Widget _typeBadge(String type) {
    bool isVideo = type == 'video';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: isVideo
              ? Colors.purple.withOpacity(0.1)
              : Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isVideo ? LucideIcons.video : LucideIcons.file_text,
              size: 12, color: isVideo ? Colors.purple : Colors.blue),
          const SizedBox(width: 4),
          Text(type.toUpperCase(),
              style: TextStyle(
                  fontSize: 10,
                  color: isVideo ? Colors.purple : Colors.blue,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    Color color = status == "Approved" ? Colors.green : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20)),
      child: Text(status,
          style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: 11)),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor)),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(value,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              Text(title,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ]),
          ],
        ),
      ),
    );
  }

  // Pick Media, Delete, and Modal logic (kept from your original)
  Future<void> _pickMedia(String type) async {
    FileType fileType = type == 'video' ? FileType.video : FileType.image;
    await FilePicker.platform.pickFiles(type: fileType);
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remove Testimony"),
        content:
            const Text("This will permanently delete this record. Proceed?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => _testimonies.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _openTestimonyModal({Map<String, dynamic>? data, int? index}) {
    final nameController = TextEditingController(text: data?['name'] ?? "");
    final contentController =
        TextEditingController(text: data?['content'] ?? "");
    String selectedType = data?['type'] ?? "text";

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Container(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data == null ? "New Testimony" : "Edit Testimony",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _typeChoice(
                        "Text",
                        LucideIcons.file_text,
                        selectedType == "text",
                        () => setModalState(() => selectedType = "text")),
                    const SizedBox(width: 12),
                    _typeChoice(
                        "Video",
                        LucideIcons.video,
                        selectedType == "video",
                        () => setModalState(() => selectedType = "video")),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                    controller: nameController,
                    decoration: _inputDecoration("Name", LucideIcons.user)),
                const SizedBox(height: 15),
                TextField(
                    controller: contentController,
                    maxLines: 3,
                    decoration: _inputDecoration("Details", LucideIcons.pen)),
                if (selectedType == 'video') ...[
                  const SizedBox(height: 15),
                  OutlinedButton.icon(
                      onPressed: () => _pickMedia('video'),
                      icon: const Icon(LucideIcons.upload),
                      label: const Text("Upload Video"))
                ]
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (index == null) {
                    _testimonies.insert(0, {
                      "name": nameController.text,
                      "type": selectedType,
                      "content": contentController.text,
                      "status": "Pending"
                    });
                  } else {
                    _testimonies[index] = {
                      "name": nameController.text,
                      "type": selectedType,
                      "content": contentController.text,
                      "status": _testimonies[index]['status']
                    };
                  }
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  Widget _typeChoice(
      String label, IconData icon, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color:
                selected ? primaryColor.withOpacity(0.05) : Colors.transparent,
            border: Border.all(color: selected ? primaryColor : borderColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(children: [
            Icon(icon, size: 18, color: selected ? primaryColor : Colors.grey),
            Text(label,
                style: TextStyle(
                    fontSize: 12, color: selected ? primaryColor : Colors.grey))
          ]),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 18),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
