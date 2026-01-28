import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class EventView extends StatefulWidget {
  const EventView({super.key});

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  final Color primaryDark = const Color(0xFF0A192F);
  final Color primaryBlue = const Color(0xFF0D47A1);
  final Color accentOrange = Colors.orangeAccent;

  // Pagination & Data state
  int _itemsToShow = 3;
  final List<Map<String, dynamic>> _allEvents = [
    {
      "title": "Global Prayer Night",
      "location": "Main Auditorium",
      "time": "08:00 PM",
      "isLive": true,
      "desc":
          "Join us for a powerful night of intercession and worship as we pray for our community and the world."
    },
    {
      "title": "Special Sunday Service",
      "location": "Main Sanctuary",
      "time": "09:00 AM",
      "isLive": false,
      "desc": "A dedicated service focused on spiritual growth and fellowship."
    },
    {
      "title": "Midweek Revival",
      "location": "Community Center",
      "time": "06:00 PM",
      "isLive": false,
      "desc":
          "Recharge your spirit in the middle of the week with deep teaching."
    },
    {
      "title": "Youth Night Live",
      "location": "Online / Zoom",
      "time": "08:00 PM",
      "isLive": false,
      "desc":
          "High energy worship and relevant messages for the next generation."
    },
    {
      "title": "Leadership Summit",
      "location": "Conference Hall B",
      "time": "10:00 AM",
      "isLive": false,
      "desc": "Strategic planning and leadership development session."
    },
    {
      "title": "Community Outreach",
      "location": "Downtown Park",
      "time": "11:00 AM",
      "isLive": false,
      "desc": "Taking our message to the streets through service and kindness."
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _loadMore() {
    setState(() {
      if (_itemsToShow < _allEvents.length) _itemsToShow += 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildModernHero(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
              child: Row(
                children: [
                  const Text(
                    "Latest Events",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A)),
                  ),
                  const Spacer(),
                  Text("Showing $_itemsToShow of ${_allEvents.length}",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final event = _allEvents[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildEventCard(event),
                  );
                },
                childCount: _itemsToShow,
              ),
            ),
          ),
          if (_itemsToShow < _allEvents.length)
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: OutlinedButton(
                  onPressed: _loadMore,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: primaryBlue),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("Load More Events",
                      style: TextStyle(
                          color: primaryBlue, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildModernHero() {
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(LucideIcons.arrow_left, color: Colors.white),
        onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
      ),
      backgroundColor: primaryDark,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              colors: [primaryDark, primaryBlue, primaryDark],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -30,
                right: -30,
                child: Icon(LucideIcons.sparkles,
                    size: 200, color: Colors.white.withOpacity(0.05)),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Church Events",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                            width: 60,
                            height: 5,
                            decoration: BoxDecoration(
                                color: accentOrange,
                                borderRadius: BorderRadius.circular(10))),
                        const SizedBox(width: 6),
                        Container(
                            width: 15,
                            height: 5,
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
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    bool isLive = event['isLive'];
    return GestureDetector(
      onTap: () => _showEventDetail(event),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 24,
                offset: const Offset(0, 8))
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(width: 6, color: isLive ? accentOrange : primaryBlue),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        _buildDynamicIcon(isLive),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isLive)
                                Text("LIVE NOW",
                                    style: TextStyle(
                                        color: accentOrange,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900)),
                              Text(event['title'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color(0xFF1E293B))),
                              const SizedBox(height: 4),
                              Text(event['time'],
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 13)),
                            ],
                          ),
                        ),
                        Icon(LucideIcons.chevron_right,
                            color: Colors.grey[300]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEventDetail(Map<String, dynamic> event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 24),
            Text(event['title'],
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
            _detailRow(LucideIcons.map_pin, event['location']),
            _detailRow(LucideIcons.clock, event['time']),
            const SizedBox(height: 16),
            Text(event['desc'],
                style: TextStyle(
                    color: Colors.grey[700], fontSize: 16, height: 1.5)),
            const SizedBox(height: 32),

            // --- UPDATED REGISTRATION BUTTON SECTION ---
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6, // Reduced width
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      elevation: 4,
                      shadowColor: primaryBlue.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30))), // Pill shape
                  onPressed: () {
                    Navigator.pop(context); // Close detail modal
                    Navigator.pushNamed(context, '/event-register');
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.user_plus, size: 20),
                      SizedBox(width: 10),
                      Text("Register Now",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10), // Bottom padding for elegance
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Icon(icon, size: 18, color: primaryBlue),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500))
      ]),
    );
  }

  Widget _buildDynamicIcon(bool isLive) {
    return isLive
        ? ScaleTransition(
            scale: Tween(begin: 1.0, end: 1.15).animate(CurvedAnimation(
                parent: _pulseController, curve: Curves.easeInOut)),
            child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: accentOrange.withOpacity(0.1),
                    shape: BoxShape.circle),
                child: Icon(LucideIcons.radio, color: accentOrange, size: 24)),
          )
        : Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.05), shape: BoxShape.circle),
            child: Icon(LucideIcons.calendar, color: primaryBlue, size: 24));
  }
}
