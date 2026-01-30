import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';

class AboutSlider extends StatefulWidget {
  const AboutSlider({super.key});

  @override
  State<AboutSlider> createState() => _AboutSliderState();
}

class _AboutSliderState extends State<AboutSlider> {
  final PageController _aboutPageController =
      PageController(viewportFraction: 0.85);
  Timer? _timer;
  int _currentPage = 0;

  final List<Map<String, String>> aboutData = [
    {
      'title': 'OUR VISION',
      'desc':
          'The Lord has called us to fulfill a very definite purpose, which is to take His divine presence to the world.',
      'image': 'assets/images/p-dee.jpeg',
    },
    {
      'title': 'WORSHIP WITH US',
      'desc':
          'Join a congregation of the mighty as we worship God in spirit and truth. Participate onsite and online.',
      'image': 'assets/images/p-dee2.jpeg',
    },
    {
      'title': 'OUR MISSION',
      'desc':
          'To raise generations of men and women who will come into their inheritance to fulfill God’s dream.',
      'image': 'assets/images/p-dee1.jpeg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < aboutData.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_aboutPageController.hasClients) {
        _aboutPageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutQuart,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _aboutPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: PageView.builder(
        controller: _aboutPageController,
        physics: const BouncingScrollPhysics(),
        itemCount: aboutData.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (context, index) => _buildSliderCard(aboutData[index]),
      ),
    );
  }

  Widget _buildSliderCard(Map<String, String> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(data['image']!),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black
                          .withOpacity(0.75), // Slightly lighter gradient
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(20)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 22),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          data['title']!.toUpperCase(),
                          style: TextStyle(
                            color: Colors.orangeAccent.withOpacity(0.9),
                            fontWeight: FontWeight.w600, // Lighter than w800
                            fontSize: 12, // Standard mobile overline
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          data['desc']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14, // Standard mobile body text
                            fontWeight: FontWeight.w400, // Lighter than w500
                            height: 1.5,
                            letterSpacing: 0.2,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
