import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async'; // Required for Timer

class AboutSlider extends StatefulWidget {
  const AboutSlider({super.key});

  @override
  State<AboutSlider> createState() => _AboutSliderState();
}

class _AboutSliderState extends State<AboutSlider> {
  // REDUCED WIDTH: Viewport fraction changed from 0.85 to 0.75
  final PageController _aboutPageController =
      PageController(viewportFraction: 0.75);
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
          'Join a congregation of the mighty as we worship God in spirit and truth. You can participate both onsite and online from anywhere in the world.',
      'image': 'assets/images/p-dee2.jpeg',
    },
    {
      'title': 'OUR MISSION',
      'desc':
          'To raise generations of men and women who will come into their inheritance to fulfill God’s dream. To make known and to bring them into their inheritance in Christ.',
      'image': 'assets/images/p-dee1.jpeg',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Start the auto-slide timer
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
      // ADJUSTED HEIGHT: Reduced from 240 to 220 for better proportions
      height: 220,
      child: PageView.builder(
        controller: _aboutPageController,
        physics: const BouncingScrollPhysics(),
        itemCount: aboutData.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          return _buildSliderCard(aboutData[index]);
        },
      ),
    );
  }

  Widget _buildSliderCard(Map<String, String> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: AssetImage(data['image']!),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Dark gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                ),
              ),
            ),
            // The Frosted Glass Text Area
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(24)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      border: Border(
                        top: BorderSide(color: Colors.white.withOpacity(0.2)),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          data['title']!,
                          style: const TextStyle(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.w900,
                            fontSize:
                                16, // Slightly reduced font size for narrower card
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data['desc']!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11, // Slightly reduced for narrow space
                              height: 1.3),
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
