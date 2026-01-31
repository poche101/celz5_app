import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class MemberTab extends StatefulWidget {
  const MemberTab({super.key});

  @override
  State<MemberTab> createState() => _MemberTabState();
}

class _MemberTabState extends State<MemberTab> {
  // Mock Data
  List<Map<String, String>> allMembers = List.generate(
    100,
    (index) => {
      'id': '${index + 1000}',
      'name': 'Member ${index + 1}',
      'title': index % 3 == 0 ? 'Deacon' : 'Brother',
      'group': index % 2 == 0 ? 'Lighthouse Group' : 'Charis Group',
      'church': index % 4 == 0 ? 'Central Church' : 'East Wing',
      'cell': index % 5 == 0 ? 'Grace Cell' : 'Victory Cell',
      'email': 'user$index@celz5.org',
    },
  );

  String _searchQuery = "";
  int _currentPage = 0;
  final int _itemsPerPage = 10;
  final int _goal = 20000;

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredMembers = allMembers.where((m) {
      final query = _searchQuery.toLowerCase();
      return m['name']!.toLowerCase().contains(query) ||
          m['id']!.contains(query) ||
          m['church']!.toLowerCase().contains(query) ||
          m['group']!.toLowerCase().contains(query) ||
          m['cell']!.toLowerCase().contains(query);
    }).toList();

    int totalFound = filteredMembers.length;
    double percentage = (allMembers.length / _goal);

    int maxPages = (totalFound / _itemsPerPage).ceil();
    if (_currentPage >= maxPages && maxPages > 0) _currentPage = maxPages - 1;
    if (totalFound == 0) _currentPage = 0;

    int start = _currentPage * _itemsPerPage;
    int end = min(start + _itemsPerPage, totalFound);
    List<Map<String, String>> displayedMembers =
        totalFound > 0 ? filteredMembers.sublist(start, end) : [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderStats(allMembers.length, percentage),
          const SizedBox(height: 32),
          _buildSearchFilter(),
          const SizedBox(height: 12),
          Text(
            _searchQuery.isEmpty
                ? "Total Directory: ${allMembers.length} members"
                : "Found $totalFound results for '$_searchQuery'",
            style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(builder: (context, constraints) {
            int crossAxisCount = constraints.maxWidth > 1400
                ? 5
                : constraints.maxWidth > 900
                    ? 3
                    : 1;
            if (displayedMembers.isEmpty) {
              return const Center(
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Text("No members found.")));
            }
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                mainAxisExtent: 260,
              ),
              itemCount: displayedMembers.length,
              itemBuilder: (context, index) =>
                  _buildMemberCard(displayedMembers[index]),
            );
          }),
          const SizedBox(height: 32),
          if (totalFound > 0) _buildPagination(totalFound, maxPages),
        ],
      ),
    );
  }

  Widget _buildSearchFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0))),
      child: TextField(
        onChanged: (value) => setState(() {
          _searchQuery = value;
          _currentPage = 0;
        }),
        decoration: const InputDecoration(
          icon: Icon(LucideIcons.search, size: 20, color: Color(0xFF94A3B8)),
          hintText: "Search by name, ID, church, group or cell...",
          border: InputBorder.none,
          hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildHeaderStats(int total, double percent) {
    return Row(
      children: [
        _statCard(
            "Total Members", total.toString(), LucideIcons.users, Colors.blue),
        const SizedBox(width: 16),
        _statCard("Goal Progress", "${(percent * 100).toStringAsFixed(1)}%",
            LucideIcons.target, const Color(0xFFF59E0B),
            subtitle: "Target: 20,000", progress: percent),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color,
      {String? subtitle, double? progress}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(label,
                  style: const TextStyle(
                      color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
              Icon(icon, color: color, size: 20),
            ]),
            const SizedBox(height: 8),
            Text(value,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            if (subtitle != null)
              Text(subtitle,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
            if (progress != null) ...[
              const SizedBox(height: 12),
              LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  backgroundColor: color.withOpacity(0.1),
                  color: color,
                  borderRadius: BorderRadius.circular(10)),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildMemberCard(Map<String, String> member) {
    const dStyle = TextStyle(color: Color(0xFF64748B), fontSize: 12);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(4)),
                child: Text("ID: ${member['id']}",
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold))),
            const Icon(LucideIcons.user_round,
                size: 14, color: Color(0xFF94A3B8)),
          ]),
          const SizedBox(height: 12),
          Text(member['name']!.toUpperCase(),
              style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: Color(0xFF0F172A)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          Text(member['title']!,
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
          const SizedBox(height: 12),
          _cardRow(LucideIcons.users, member['group']!, dStyle),
          const SizedBox(height: 6),
          _cardRow(LucideIcons.church, member['church']!, dStyle),
          const SizedBox(height: 6),
          _cardRow(LucideIcons.layers, member['cell']!, dStyle),
          const Spacer(),
          const Divider(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            _actionBtn(
                LucideIcons.pencil, Colors.blue, () => _showEditDialog(member)),
            const SizedBox(width: 8),
            _actionBtn(LucideIcons.trash_2, Colors.redAccent,
                () => _confirmDelete(member)),
          ])
        ],
      ),
    );
  }

  Widget _cardRow(IconData icon, String text, TextStyle style) {
    return Row(children: [
      Icon(icon, size: 14, color: const Color(0xFF94A3B8)),
      const SizedBox(width: 8),
      Expanded(child: Text(text, style: style, overflow: TextOverflow.ellipsis))
    ]);
  }

  Widget _actionBtn(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6)),
            child: Icon(icon, size: 16, color: color)));
  }

  // --- REFACTORED CENTER DIALOG ---
  void _showEditDialog(Map<String, String> member) {
    final nameCtrl = TextEditingController(text: member['name']);
    final churchCtrl = TextEditingController(text: member['church']);
    final groupCtrl = TextEditingController(text: member['group']);
    final cellCtrl = TextEditingController(text: member['cell']);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400), // Reduced width
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Edit Member Profile",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                      labelText: "Full Name",
                      prefixIcon: Icon(LucideIcons.user, size: 18))),
              TextField(
                  controller: churchCtrl,
                  decoration: const InputDecoration(
                      labelText: "Church",
                      prefixIcon: Icon(LucideIcons.church, size: 18))),
              TextField(
                  controller: groupCtrl,
                  decoration: const InputDecoration(
                      labelText: "Group",
                      prefixIcon: Icon(LucideIcons.users, size: 18))),
              TextField(
                  controller: cellCtrl,
                  decoration: const InputDecoration(
                      labelText: "Cell",
                      prefixIcon: Icon(LucideIcons.layers, size: 18))),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        setState(() {
                          int index = allMembers
                              .indexWhere((m) => m['id'] == member['id']);
                          if (index != -1) {
                            allMembers[index] = {
                              ...allMembers[index],
                              'name': nameCtrl.text,
                              'church': churchCtrl.text,
                              'group': groupCtrl.text,
                              'cell': cellCtrl.text
                            };
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Save",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(Map<String, String> member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Member?"),
        content: Text("Remove ${member['name']} from the records?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                setState(() =>
                    allMembers.removeWhere((m) => m['id'] == member['id']));
                Navigator.pop(context);
              },
              child:
                  const Text("Delete", style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  Widget _buildPagination(int total, int maxPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            icon: const Icon(LucideIcons.chevron_left),
            onPressed:
                _currentPage > 0 ? () => setState(() => _currentPage--) : null),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8)),
            child: Text("Page ${_currentPage + 1} of $maxPages",
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13))),
        IconButton(
            icon: const Icon(LucideIcons.chevron_right),
            onPressed: (_currentPage + 1) < maxPages
                ? () => setState(() => _currentPage++)
                : null),
      ],
    );
  }
}
