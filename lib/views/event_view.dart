import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

// --- 1. THE DATA MODEL ---
// This must be outside of your State classes to be accessible
class ChurchEvent {
  final String id;
  final String title;
  final String date;
  final String time;
  final String image;
  final String description;
  final bool isLive;

  ChurchEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.image,
    required this.description,
    this.isLive = false,
  });

  // This converts raw API/Map data into a ChurchEvent object
  factory ChurchEvent.fromJson(Map<String, dynamic> json) {
    return ChurchEvent(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Untitled Event',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      image: json['image'] ?? 'https://via.placeholder.com/800',
      description: json['desc'] ?? '',
      isLive: json['isLive'] ?? false,
    );
  }
}

// --- 2. THE WIDGET ---
class EventView extends StatefulWidget {
  const EventView({super.key});

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  // State variables
  List<ChurchEvent> _events = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _itemsToShow = 3;

  final Color primaryBlue = const Color(0xFF0D47A1);
  final Color accentOrange = Colors.orangeAccent;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _fetchEvents();
  }

  // SIMULATED API CALL
  Future<void> _fetchEvents() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      await Future.delayed(const Duration(seconds: 2));

      // Raw data usually received from an API
      final List<Map<String, dynamic>> mockData = [
        {
          "id": "1",
          "title": "Global Prayer Night",
          "date": "Friday, 15th Feb",
          "isLive": true,
          "image":
              "https://images.unsplash.com/photo-1510531704581-5b2870972060?q=80&w=800",
          "desc": "Join us for a powerful night of intercession and worship."
        },
        {
          "id": "2",
          "title": "Special Sunday Service",
          "date": "Sunday, 17th Feb",
          "isLive": false,
          "image":
              "https://images.unsplash.com/photo-1438232992991-995b7058bbb3?q=80&w=800",
          "desc": "A dedicated service focused on spiritual growth."
        },
        {
          "id": "3",
          "title": "Midweek Revival",
          "date": "Wednesday, 20th Feb",
          "isLive": false,
          "image":
              "https://images.unsplash.com/photo-1515162305285-0293e4767cc2?q=80&w=800",
          "desc": "Recharge your spirit in the middle of the week."
        },
        {
          "id": "4",
          "title": "Youth Night Live",
          "date": "Friday, 22nd Feb",
          "isLive": false,
          "image":
              "https://images.unsplash.com/photo-1523580494863-6f3031224c94?q=80&w=800",
          "desc": "High energy worship for the next generation."
        },
      ];

      setState(() {
        _events = mockData.map((e) => ChurchEvent.fromJson(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load events. Please try again.";
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: RefreshIndicator(
        onRefresh: _fetchEvents,
        color: primaryBlue,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildModernHero(),
            _buildSectionHeader(),
            _buildContent(),
            _buildLoadMoreButton(),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }

  // --- UI PIECES ---

  Widget _buildSectionHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
        child: Row(
          children: [
            const Text(
              "Upcoming Events",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A)),
            ),
            const Spacer(),
            if (!_isLoading && _events.isNotEmpty)
              Text(
                "${_itemsToShow > _events.length ? _events.length : _itemsToShow} of ${_events.length}",
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: Text(_errorMessage!)),
      );
    }

    if (_events.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: Text("No events scheduled.")),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildVerticalEventCard(_events[index]),
          childCount:
              _itemsToShow > _events.length ? _events.length : _itemsToShow,
        ),
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    if (_isLoading || _itemsToShow >= _events.length) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Center(
          child: TextButton(
            onPressed: () => setState(() => _itemsToShow += 2),
            child: Text(
              "Load More",
              style: TextStyle(
                  fontSize: 15,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernHero() {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: primaryBlue,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              "https://images.unsplash.com/photo-1544427920-c49ccfb85579?q=80&w=1200",
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, primaryBlue.withOpacity(0.9)],
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "CHURCH\nEVENTS",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        height: 1.0,
                        fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                              color: accentOrange,
                              borderRadius: BorderRadius.circular(10))),
                      const SizedBox(width: 6),
                      Container(
                          width: 12,
                          height: 4,
                          decoration: BoxDecoration(
                              color: accentOrange,
                              borderRadius: BorderRadius.circular(10))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalEventCard(ChurchEvent event) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.05),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showRegistrationDialog(event),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.network(event.image,
                        height: 160, width: double.infinity, fit: BoxFit.cover),
                  ),
                  if (event.isLive)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: FadeTransition(
                        opacity: _pulseController,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(12)),
                          child: const Text("LIVE",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 10)),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(LucideIcons.calendar,
                            size: 16, color: primaryBlue),
                        const SizedBox(width: 8),
                        Text(event.date,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700])),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRegistrationDialog(ChurchEvent event) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.7),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(24)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Material(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDialogHeader(event),
                    _buildDialogBody(event),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogHeader(ChurchEvent event) {
    return SizedBox(
      height: 160,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(event.image, fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.2)),
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const CircleAvatar(
                radius: 14,
                backgroundColor: Colors.black26,
                child: Icon(LucideIcons.x, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogBody(ChurchEvent event) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(event.title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(
            event.description,
            style:
                TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Confirm Attendance",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
