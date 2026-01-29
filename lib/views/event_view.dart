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

  final Color primaryBlue = const Color(0xFF0D47A1);
  final Color accentOrange = Colors.orangeAccent;

  int _itemsToShow = 3;

  final List<Map<String, dynamic>> _allEvents = [
    {
      "title": "Global Prayer Night",
      "date": "Friday, 15th Feb",
      "time": "08:00 PM",
      "isLive": true,
      "image":
          "https://images.unsplash.com/photo-1510531704581-5b2870972060?q=80&w=800",
      "desc": "Join us for a powerful night of intercession and worship."
    },
    {
      "title": "Special Sunday Service",
      "date": "Sunday, 17th Feb",
      "time": "09:00 AM",
      "isLive": false,
      "image":
          "https://images.unsplash.com/photo-1438232992991-995b7058bbb3?q=80&w=800",
      "desc": "A dedicated service focused on spiritual growth."
    },
    {
      "title": "Midweek Revival",
      "date": "Wednesday, 20th Feb",
      "time": "06:00 PM",
      "isLive": false,
      "image":
          "https://images.unsplash.com/photo-1515162305285-0293e4767cc2?q=80&w=800",
      "desc": "Recharge your spirit in the middle of the week."
    },
    {
      "title": "Youth Night Live",
      "date": "Friday, 22nd Feb",
      "time": "08:00 PM",
      "isLive": false,
      "image":
          "https://images.unsplash.com/photo-1523580494863-6f3031224c94?q=80&w=800",
      "desc": "High energy worship for the next generation."
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
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
                    "Upcoming Events",
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
                (context, index) => _buildVerticalEventCard(_allEvents[index]),
                childCount: _itemsToShow,
              ),
            ),
          ),
          if (_itemsToShow < _allEvents.length)
            SliverToBoxAdapter(
              child: Center(
                child: TextButton(
                  onPressed: () => setState(() => _itemsToShow++),
                  child: Text("Load More",
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
      backgroundColor: primaryBlue,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
                "https://images.unsplash.com/photo-1544427920-c49ccfb85579?q=80&w=1200",
                fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, primaryBlue.withOpacity(0.8)],
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("CHURCH EVENTS",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                              color: accentOrange,
                              borderRadius: BorderRadius.circular(10))),
                      const SizedBox(width: 6),
                      Container(
                          width: 12,
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
    );
  }

  Widget _buildVerticalEventCard(Map<String, dynamic> event) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        elevation: 2,
        shadowColor: Colors.black12,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => _showRegistrationDialog(event),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                    child: Image.network(event['image'],
                        height: 180, width: double.infinity, fit: BoxFit.cover),
                  ),
                  if (event['isLive'] == true)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: FadeTransition(
                        opacity: _pulseController,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(20)),
                          child: const Text("LIVE",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event['title'],
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(LucideIcons.calendar,
                            size: 16, color: primaryBlue),
                        const SizedBox(width: 8),
                        Text(event['date']),
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

  void _showRegistrationDialog(Map<String, dynamic> event) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: ScaleTransition(
            scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Material(
                  color: Colors.white,
                  child: Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // RESTRICTED BANNER AREA
                          SizedBox(
                            height: 160,
                            width: double.infinity,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(event['image'],
                                    fit: BoxFit.cover),
                                Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black45,
                                        Colors.transparent
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // CONTENT AREA
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event['title'],
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  event['desc'],
                                  style: TextStyle(
                                      color: Colors.grey[600], height: 1.4),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  height: 54,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryBlue,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14)),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamed(
                                          context, '/event-register');
                                    },
                                    child: const Text(
                                      "Confirm Attendance",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // PROFESSIONAL CLOSE BUTTON
                      Positioned(
                        top: 12,
                        right: 12,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              LucideIcons.x,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
