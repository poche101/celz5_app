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
    // Using networkUrl for better performance/compatibility
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
          "https://s3.eu-west-2.amazonaws.com/lodams-videoshare/videos/h-life15_601699fe3ccc7b0007cbc451.mp4"),
    )..initialize().then((_) {
        _controller.setVolume(0);
        _controller.setLooping(true);
        _controller.play();
        setState(() {}); // Refresh to show the video once initialized
      });
  }

  @override
  void dispose() {
    // CRITICAL: Always dispose controllers to fix memory leaks
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
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextHeader(),
          const SizedBox(height: 8),
          _buildAccentLine(),
          const SizedBox(height: 20),
          _buildVideoContainer(),
        ],
      ),
    );
  }

  Widget _buildTextHeader() {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(
            text: "The Higher Life\n",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0A192F),
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          TextSpan(
            text: "With Pastor Deola Phillips",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
              color: const Color(0xFF0A192F).withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccentLine() {
    return Row(
      children: [
        Container(
          height: 3,
          width: 35,
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(width: 4),
        Container(
          height: 3,
          width: 8,
          decoration: BoxDecoration(
            color: Colors.orangeAccent.withOpacity(0.3),
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
        height: 220,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
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
                      child:
                          CircularProgressIndicator(color: Colors.orangeAccent),
                    ),
              Positioned(
                top: 15,
                right: 15,
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
        padding: const EdgeInsets.all(8),
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
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
          ),
        ],
      ),
    );
  }
}
