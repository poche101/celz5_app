import 'package:flutter/material.dart';

class VideoHeroSection extends StatelessWidget {
  final Function(int) onAction;

  // Ensure this exact path exists in your file explorer
  final String heroImageUrl = 'assets/images/tvnew.jpg';

  const VideoHeroSection({super.key, required this.onAction});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: double.infinity,
      height: size.height * 0.85,
      child: Stack(
        children: [
          // 1. Soft Base Layer
          Container(color: const Color(0xFFF8FAFC)),

          // 2. The Image Layer
          Positioned.fill(
            child: Image.asset(
              heroImageUrl,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              // This acts as a diagnostic - if you see this text,
              // the problem is your folder structure or pubspec.yaml
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.red[50],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(height: 8),
                        Text(
                          'Missing: $heroImageUrl',
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 3. The Sleek Premium Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color.fromARGB(255, 106, 108, 243).withOpacity(0.08),
                    const Color(0xFFBAE6FD).withOpacity(0.18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
