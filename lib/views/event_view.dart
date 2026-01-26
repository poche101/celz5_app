import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:intl/intl.dart';

class EventView extends StatefulWidget {
  // REMOVED 'const' - This is the most common fix for the main.dart error
  const EventView({super.key});

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

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
    final double width = MediaQuery.of(context).size.width;
    final bool isDesktop = width > 1100;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverPadding(
            padding: EdgeInsets.all(isDesktop ? 40 : 16),
            sliver: SliverToBoxAdapter(
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 4, child: _buildCalendarCard()),
                        const SizedBox(width: 32),
                        Expanded(flex: 6, child: _buildEventList()),
                      ],
                    )
                  : Column(
                      children: [
                        _buildCalendarCard(),
                        const SizedBox(height: 24),
                        _buildEventList(),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      pinned: true,
      stretch: true,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
      title: const Text(
        "Upcoming Events",
        style: TextStyle(
          color: Color(0xFF0F172A),
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
          fontSize: 22,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            // FIXED: Using 'sliders_horizontal' which is more stable across versions
            icon: const Icon(
              LucideIcons.sliders_horizontal,
              color: Color(0xFF64748B),
              size: 18,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Calendar",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  DateFormat('MMM yyyy').format(DateTime.now()),
                  style: const TextStyle(
                    color: Color(0xFF6366F1),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            height: 280,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.calendar_days,
                    size: 40,
                    color: Color(0xFFCBD5E1),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Syncing church events...",
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    return Column(
      children: [
        _buildEventItem(
          "Special Sunday Service",
          "Main Auditorium",
          "09:00 AM",
          true,
        ),
        const SizedBox(height: 12),
        _buildEventItem(
          "Midweek Prayer Meeting",
          "Online / Zoom",
          "06:30 PM",
          false,
        ),
        const SizedBox(height: 12),
        _buildEventItem(
          "Youth Mega Conference",
          "Grand Hall B",
          "10:00 AM",
          false,
        ),
      ],
    );
  }

  Widget _buildEventItem(
    String title,
    String location,
    String time,
    bool isLive,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showEventDetails(title, location, time),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: _cardDecoration(),
          child: Row(
            children: [
              isLive ? _buildPulseIcon() : _buildStaticIcon(),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          LucideIcons.map_pin,
                          size: 14,
                          color: Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          location,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          LucideIcons.clock,
                          size: 14,
                          color: Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          time,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                LucideIcons.chevron_right,
                color: Color(0xFFCBD5E1),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPulseIcon() {
    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.15).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFEE2E2),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.15),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(
          LucideIcons.radio,
          color: Color(0xFFEF4444),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildStaticIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Color(0xFFF1F5F9),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        LucideIcons.calendar,
        color: Color(0xFF64748B),
        size: 20,
      ),
    );
  }

  void _showEventDetails(String title, String location, String time) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _EventDetailSheet(title: title, location: location, time: time),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFEDF2F7), width: 1.5),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF0F172A).withOpacity(0.04),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}

class _EventDetailSheet extends StatelessWidget {
  final String title, location, time;
  const _EventDetailSheet({
    required this.title,
    required this.location,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 24),
          _detailRow(LucideIcons.map_pin, "Location", location),
          _detailRow(LucideIcons.clock, "Time", time),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Save to Calendar",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF6366F1)),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
