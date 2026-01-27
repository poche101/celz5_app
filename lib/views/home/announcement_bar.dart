import 'dart:async';
import 'package:flutter/material.dart';

class AnnouncementBar extends StatefulWidget {
  const AnnouncementBar({super.key});

  @override
  State<AnnouncementBar> createState() => _AnnouncementBarState();
}

class _AnnouncementBarState extends State<AnnouncementBar> {
  late ScrollController _scrollController;
  late Timer _scrollTimer;
  final List<String> _announcements = [
    "✨ Welcome to CELZ5: Experience the Extraordinary Presence of God!",
    "📅 Upcoming: Global Communion Service with Pastor Chris - Sunday 4PM GMT",
    "🙏 Join the Global Prayer Network every morning at 5:00 AM",
    "📖 New Rhapsody of Realities daily devotional now available for download",
    "💒 Mid-week Service starts Wednesday at 6:00 PM. Don't miss out!",
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  void _startScrolling() {
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.offset;
        if (currentScroll >= maxScroll) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.animateTo(
            currentScroll + 1,
            duration: const Duration(milliseconds: 50),
            curve: Curves.linear,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A192F), Color(0xFF0D47A1), Color(0xFF0A192F)],
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.orangeAccent[700],
            alignment: Alignment.center,
            child: const Text("LATEST",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(_announcements[index % _announcements.length],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
