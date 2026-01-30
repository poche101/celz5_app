import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class HigherLifeVideoSection extends StatefulWidget {
  const HigherLifeVideoSection({super.key});

  @override
  State<HigherLifeVideoSection> createState() => _HigherLifeVideoSectionState();
}

class _HigherLifeVideoSectionState extends State<HigherLifeVideoSection> {
  late VideoPlayerController _controller;
  bool _showControls = true;
  bool _isMuted = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
          "https://s3.eu-west-2.amazonaws.com/lodams-videoshare/videos/h-life15_601699fe3ccc7b0007cbc451.mp4"),
    )..initialize().then((_) {
        _controller.setVolume(0);
        _controller.setLooping(true);
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0 : 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Centered the column items
        children: [
          _buildCenteredHeader(),
          const SizedBox(height: 12),
          _buildCenteredAccentLine(),
          const SizedBox(height: 28),
          _buildVideoContainer(),
        ],
      ),
    );
  }

  Widget _buildCenteredHeader() {
    return Column(
      children: [
        const Text(
          "The Higher Life",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24, // Standard Mobile Headline Size
            fontWeight: FontWeight.w900,
            color: Color(0xFF0A192F),
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "With Pastor Deola Phillips",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14, // Standard Mobile Body Size
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }

  Widget _buildCenteredAccentLine() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center the underline
      children: [
        Container(
          height: 4,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(width: 4),
        Container(
          height: 4,
          width: 10,
          decoration: BoxDecoration(
            color: Colors.orangeAccent.withOpacity(0.25),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoContainer() {
    return GestureDetector(
      onTap: () => setState(() => _showControls = !_showControls),
      child: Container(
        height: 220, // Adjusted for standard mobile aspect ratio comfort
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0A192F).withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 12),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            alignment: Alignment.center,
            children: [
              _controller.value.isInitialized
                  ? Center(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        color: Colors.orangeAccent,
                        strokeWidth: 2,
                      ),
                    ),
              Positioned(
                top: 16,
                right: 16,
                child: _buildMuteButton(),
              ),
              if (_showControls || !_controller.value.isPlaying)
                _buildOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMuteButton() {
    return GestureDetector(
      onTap: _toggleMute,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          _isMuted ? LucideIcons.volume_x : LucideIcons.volume_2,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: Stack(
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  _controller.value.isPlaying
                      ? LucideIcons.pause
                      : LucideIcons.play,
                  color: Colors.white,
                  size: 44,
                ),
                onPressed: () => setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                }),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Colors.orangeAccent,
                bufferedColor: Colors.white24,
                backgroundColor: Colors.white10,
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            ),
          ),
        ],
      ),
    );
  }
}
