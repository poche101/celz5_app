import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:file_picker/file_picker.dart';

class EventTab extends StatefulWidget {
  const EventTab({super.key});

  @override
  State<EventTab> createState() => _EventTabState();
}

class _EventTabState extends State<EventTab> {
  // Theme Colors
  final Color primaryColor = const Color(0xFF0F172A); // Slate 900
  final Color secondaryColor = const Color(0xFF3B82F6); // Blue 500
  final Color surfaceColor = const Color(0xFFF8FAFC);
  final Color borderColor = const Color(0xFFE2E8F0);

  bool _isLoading = false;
  List<Map<String, dynamic>> _events = [];

  // --- SEARCH & PAGINATION STATE ---
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 1;
  int _rowsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate API

    setState(() {
      _events = [
        {
          "id": "1",
          "title": "Global Prayer Night",
          "date": "2024-02-15",
          "time": "19:00",
          "location": "Main Sanctuary",
          "isLive": true,
          "image":
              "https://images.unsplash.com/photo-1510531704581-5b2870972060?q=80&w=200",
        },
        {
          "id": "2",
          "title": "Special Sunday Service",
          "date": "2024-02-17",
          "time": "09:00",
          "location": "Grace Hall",
          "isLive": false,
          "image":
              "https://images.unsplash.com/photo-1438232992991-995b7058bbb3?q=80&w=200",
        },
        {
          "id": "3",
          "title": "Youth Fellowship",
          "date": "2024-02-20",
          "time": "17:30",
          "location": "Youth Center",
          "isLive": false,
          "image":
              "https://images.unsplash.com/photo-1523580494863-6f3031224c94?q=80&w=200"
        },
        {
          "id": "4",
          "title": "Mid-week Service",
          "date": "2024-02-22",
          "time": "18:00",
          "location": "Online / Chapel",
          "isLive": false,
          "image":
              "https://images.unsplash.com/photo-1511795409834-ef04bbd61622?q=80&w=200"
        },
        {
          "id": "5",
          "title": "Choir Rehearsal",
          "date": "2024-02-23",
          "time": "16:00",
          "location": "Music Room",
          "isLive": false,
          "image":
              "https://images.unsplash.com/photo-1459749411177-042180ce673c?q=80&w=200"
        },
        {
          "id": "6",
          "title": "Leadership Meeting",
          "date": "2024-02-25",
          "time": "10:00",
          "location": "Conference Room B",
          "isLive": false,
          "image":
              "https://images.unsplash.com/photo-1475721027185-39a12947c048?q=80&w=200"
        },
      ];
      _isLoading = false;
    });
  }

  // --- LOGIC HELPERS ---

  List<Map<String, dynamic>> get _filteredEvents {
    if (_searchQuery.isEmpty) return _events;
    return _events
        .where((e) => e['title']
            .toString()
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  List<Map<String, dynamic>> get _paginatedEvents {
    final filtered = _filteredEvents;
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    if (startIndex >= filtered.length) return [];
    final endIndex = startIndex + _rowsPerPage;
    return filtered.sublist(
        startIndex, endIndex > filtered.length ? filtered.length : endIndex);
  }

  int get _totalPages => (_filteredEvents.length / _rowsPerPage).ceil();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: surfaceColor,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildStatsRow(),
                  const SizedBox(height: 32),
                  _buildEventTable(),
                ],
              ),
            ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Event Management",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A)),
            ),
            Text("Create, edit and manage your church events schedule.",
                style: TextStyle(color: Color(0xFF64748B))),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showEventModal(),
          icon: const Icon(LucideIcons.plus, size: 18, color: Colors.white),
          label: const Text("Create New Event",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          style: ElevatedButton.styleFrom(
            backgroundColor: secondaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
        _statCard("Total Events", _events.length.toString(),
            LucideIcons.calendar_days, Colors.blue),
        const SizedBox(width: 20),
        _statCard(
            "Live Now",
            _events.where((e) => e['isLive']).length.toString(),
            LucideIcons.radio,
            Colors.red),
        const SizedBox(width: 20),
        _statCard("Upcoming", "12", LucideIcons.clock, Colors.orange),
      ],
    );
  }

  Widget _buildEventTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("All Scheduled Events",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 300,
                  height: 40,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() {
                      _searchQuery = val;
                      _currentPage = 1;
                    }),
                    decoration: InputDecoration(
                      hintText: "Search events...",
                      prefixIcon: const Icon(LucideIcons.search, size: 18),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: borderColor)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(surfaceColor),
              horizontalMargin: 24,
              columnSpacing: 40,
              columns: const [
                DataColumn(label: Text("EVENT INFO")),
                DataColumn(label: Text("DATE & TIME")),
                DataColumn(label: Text("LOCATION")),
                DataColumn(label: Text("STATUS")),
                DataColumn(label: Text("ACTIONS")),
              ],
              rows: _paginatedEvents.map((event) {
                final actualIndex = _events.indexOf(event);

                return DataRow(cells: [
                  DataCell(Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(event['image'],
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey[200],
                                width: 40,
                                height: 40,
                                child:
                                    const Icon(LucideIcons.image, size: 16))),
                      ),
                      const SizedBox(width: 12),
                      Text(event['title'],
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  )),
                  DataCell(Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event['date'], style: const TextStyle(fontSize: 13)),
                      Text(event['time'] ?? "N/A",
                          style:
                              TextStyle(fontSize: 11, color: Colors.grey[600])),
                    ],
                  )),
                  DataCell(Row(
                    children: [
                      const Icon(LucideIcons.map_pin,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(event['location'] ?? "TBD",
                          style: const TextStyle(fontSize: 13)),
                    ],
                  )),
                  DataCell(_statusBadge(event['isLive'])),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: const Icon(LucideIcons.pencil,
                            size: 18, color: Colors.blueGrey),
                        onPressed: () =>
                            _showEventModal(data: event, index: actualIndex),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.trash_2,
                            size: 18, color: Colors.redAccent),
                        onPressed: () => _confirmDelete(actualIndex),
                      ),
                    ],
                  )),
                ]);
              }).toList(),
            ),
          ),
          if (_filteredEvents.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child:
                  Center(child: Text("No events found matching your search.")),
            ),
          _buildPaginationFooter(),
        ],
      ),
    );
  }

  Widget _buildPaginationFooter() {
    final filteredCount = _filteredEvents.length;
    if (filteredCount == 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Showing ${((_currentPage - 1) * _rowsPerPage) + 1} to ${_currentPage * _rowsPerPage > filteredCount ? filteredCount : _currentPage * _rowsPerPage} of $filteredCount results",
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(LucideIcons.chevron_left, size: 18),
                onPressed: _currentPage > 1
                    ? () => setState(() => _currentPage--)
                    : null,
              ),
              const SizedBox(width: 8),
              ...List.generate(_totalPages, (index) {
                int pageNum = index + 1;
                return GestureDetector(
                  onTap: () => setState(() => _currentPage = pageNum),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _currentPage == pageNum
                          ? secondaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "$pageNum",
                      style: TextStyle(
                        color: _currentPage == pageNum
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(LucideIcons.chevron_right, size: 18),
                onPressed: _currentPage < _totalPages
                    ? () => setState(() => _currentPage++)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- MODALS & LOGIC ---

  void _showEventModal({Map<String, dynamic>? data, int? index}) {
    final titleController = TextEditingController(text: data?['title'] ?? "");
    final dateController = TextEditingController(text: data?['date'] ?? "");
    final timeController = TextEditingController(text: data?['time'] ?? "");
    final locationController =
        TextEditingController(text: data?['location'] ?? "");
    bool isLive = data?['isLive'] ?? false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: Text(data == null ? "Create New Event" : "Edit Event"),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _modalTextField(
                      titleController, "Event Title", LucideIcons.type),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: _modalTextField(dateController,
                              "Date (YYYY-MM-DD)", LucideIcons.calendar)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _modalTextField(timeController,
                              "Time (e.g. 10:00 AM)", LucideIcons.clock)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _modalTextField(locationController, "Location / Venue",
                      LucideIcons.map_pin),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text("Set as Live Event"),
                    secondary: Icon(LucideIcons.radio,
                        color: isLive ? Colors.red : Colors.grey),
                    value: isLive,
                    onChanged: (v) => setModalState(() => isLive = v),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () async => await FilePicker.platform
                        .pickFiles(type: FileType.image),
                    icon: const Icon(LucideIcons.image),
                    label: const Text("Select Cover Photo"),
                    style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50)),
                  )
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              onPressed: () {
                setState(() {
                  final newEvent = {
                    "title": titleController.text,
                    "date": dateController.text,
                    "time": timeController.text,
                    "location": locationController.text,
                    "isLive": isLive,
                    "image": data?['image'] ?? "https://via.placeholder.com/200"
                  };
                  if (index == null) {
                    _events.insert(0, newEvent);
                  } else {
                    _events[index] = newEvent;
                  }
                });
                Navigator.pop(context);
              },
              child: const Text("Save Event",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Event?"),
        content: const Text("This action cannot be undone. Are you sure?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                _events.removeAt(index);
                if (_paginatedEvents.isEmpty && _currentPage > 1) {
                  _currentPage--;
                }
              });
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  // --- HELPERS ---

  Widget _statCard(String title, String val, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(val,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                Text(title,
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(bool isLive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isLive
            ? Colors.red.withOpacity(0.1)
            : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isLive ? "LIVE" : "SCHEDULED",
        style: TextStyle(
            color: isLive ? Colors.red : Colors.green,
            fontSize: 11,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _modalTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
