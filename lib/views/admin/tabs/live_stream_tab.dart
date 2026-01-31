import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class LiveStreamTab extends StatefulWidget {
  const LiveStreamTab({super.key});

  @override
  State<LiveStreamTab> createState() => _LiveStreamTabState();
}

class _LiveStreamTabState extends State<LiveStreamTab> {
  bool _isLive = false;

  // Controllers for Filters
  final TextEditingController _attendanceSearchController =
      TextEditingController();
  String _attendanceFilter = "";

  // Mock Data for Comments (Moved to state so they can be modified)
  final List<Map<String, dynamic>> _comments = [
    {
      "id": "1",
      "user": "Sister Jane",
      "text": "The message is so powerful! Watching from London.",
      "time": "2m ago",
      "reply": null
    },
    {
      "id": "2",
      "user": "Brother Mark",
      "text": "Glory to God for this session.",
      "time": "5m ago",
      "reply": "Amen! Glad you are tuned in."
    },
  ];

  // Mock Data for Attendees
  final List<Map<String, String>> _attendees = [
    {
      "name": "John Doe",
      "phone": "+234 801 234 5678",
      "status": "Online",
      "date": "2023-10-24"
    },
    {
      "name": "Sarah Williams",
      "phone": "+44 7700 900077",
      "status": "Online",
      "date": "2023-10-24"
    },
    {
      "name": "David Chen",
      "phone": "+1 202 555 0123",
      "status": "Just left",
      "date": "2023-10-23"
    },
    {
      "name": "Emmanuel Okoro",
      "phone": "+234 902 111 2233",
      "status": "Online",
      "date": "2023-10-22"
    },
  ];

  // --- LOGIC FOR COMMENTS ---

  void _editComment(int index) {
    TextEditingController editController =
        TextEditingController(text: _comments[index]['text']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Comment"),
        content: TextField(controller: editController, maxLines: 3),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() => _comments[index]['text'] = editController.text);
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteComment(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Comment"),
        content: const Text(
            "Are you sure you want to remove this comment? This action cannot be undone."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => _comments.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showReplyDialog(int index) {
    TextEditingController replyController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Reply to ${_comments[index]['user']}"),
        content: TextField(
          controller: replyController,
          decoration: const InputDecoration(hintText: "Type your reply..."),
          maxLines: 3,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() => _comments[index]['reply'] = replyController.text);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1)),
            child:
                const Text("Send Reply", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _buildStreamConfigCard(),
                    const SizedBox(height: 24),
                    _buildAttendanceCard(),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                flex: 2,
                child: _buildLiveChatCard(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Broadcast Studio",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A)),
            ),
            Text(
              "Manage scheduled meetings and monitor live engagement",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _isLive ? Colors.red.shade50 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: _isLive ? Colors.red.shade200 : Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Icon(LucideIcons.radio,
                  size: 18, color: _isLive ? Colors.red : Colors.grey),
              const SizedBox(width: 12),
              Text(
                _isLive ? "BROADCAST ACTIVE" : "STUDIO OFFLINE",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _isLive ? Colors.red : Colors.grey.shade700,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 12),
              Switch(
                value: _isLive,
                activeColor: Colors.red,
                onChanged: (val) => setState(() => _isLive = val),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStreamConfigCard() {
    return _buildGlassCard(
      title: "Stream Scheduling",
      icon: LucideIcons.calendar_plus,
      child: Column(
        children: [
          _buildInputField(
              "Meeting Title", "e.g., Global Prayer Week", LucideIcons.heading),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _buildInputField(
                      "Date", "Select Date", LucideIcons.calendar)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildInputField(
                      "Time", "Select Time", LucideIcons.clock)),
            ],
          ),
          const SizedBox(height: 16),
          _buildInputField(
              "Stream Link", "https://youtube.com/live/...", LucideIcons.link),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {},
              child: const Text("Update Broadcast Details",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard() {
    // Filter Logic
    final filteredList = _attendees.where((person) {
      final query = _attendanceFilter.toLowerCase();
      return person['name']!.toLowerCase().contains(query) ||
          person['date']!.contains(query);
    }).toList();

    return _buildGlassCard(
      title: "Live Attendance",
      icon: LucideIcons.users,
      child: Column(
        children: [
          // Filter Input
          TextField(
            controller: _attendanceSearchController,
            onChanged: (val) => setState(() => _attendanceFilter = val),
            decoration: InputDecoration(
              hintText: "Filter by name or date (YYYY-MM-DD)",
              prefixIcon: const Icon(LucideIcons.search, size: 18),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 20),
          ...filteredList.map((person) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: Icon(LucideIcons.user,
                          size: 16, color: Colors.indigo.shade400),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(person['name']!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                          Text("${person['phone']!} • ${person['date']!}",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                    _statusBadge(person['status']!),
                  ],
                ),
              )),
          if (filteredList.isEmpty)
            const Padding(
                padding: EdgeInsets.all(16.0), child: Text("No results found")),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => setState(() => _attendanceFilter = ""),
            icon: const Icon(LucideIcons.list_filter, size: 16),
            label: const Text("Reset Filters"),
          )
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    bool isOnline = status == "Online";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOnline ? Colors.green.shade100 : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isOnline ? Colors.green.shade700 : Colors.orange.shade700),
      ),
    );
  }

  Widget _buildLiveChatCard() {
    return _buildGlassCard(
      title: "Live Engagement",
      icon: LucideIcons.message_circle,
      child: Column(
        children: [
          SizedBox(
            height: 500,
            child: ListView.separated(
              itemCount: _comments.length,
              separatorBuilder: (_, __) => const Divider(height: 32),
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                            backgroundColor: Colors.indigo.shade100,
                            child: Text(comment['user']![0])),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(comment['user']!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(comment['time']!,
                                      style: const TextStyle(
                                          fontSize: 10, color: Colors.grey)),
                                ],
                              ),
                              Text(comment['text']!,
                                  style: const TextStyle(
                                      fontSize: 13, color: Color(0xFF334155))),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (comment['reply'] != null)
                      Container(
                        margin: const EdgeInsets.only(left: 44, top: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.indigo.shade100),
                        ),
                        child: Row(
                          children: [
                            const Icon(LucideIcons.corner_down_right,
                                size: 14, color: Colors.indigo),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Admin: ${comment['reply']}",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.indigo.shade900,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 44, top: 8),
                      child: Row(
                        children: [
                          _actionTextButton(
                              "Reply",
                              LucideIcons.message_square_quote,
                              Colors.indigo,
                              () => _showReplyDialog(index)),
                          const SizedBox(width: 16),
                          _actionTextButton("Edit", LucideIcons.pencil,
                              Colors.blue, () => _editComment(index)),
                          const SizedBox(width: 16),
                          _actionTextButton("Delete", LucideIcons.trash_2,
                              Colors.red, () => _confirmDeleteComment(index)),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- REUSABLE UI COMPONENTS ---

  Widget _buildGlassCard(
      {required String title, required IconData icon, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 20,
              offset: const Offset(0, 10))
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF6366F1)),
              const SizedBox(width: 12),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 16), child: Divider()),
          child,
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String hint, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Color(0xFF64748B))),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18),
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _actionTextButton(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
