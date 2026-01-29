import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class HigherLifeArchiveApp extends StatelessWidget {
  const HigherLifeArchiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: YouTubeStylePlayer(),
    );
  }
}

class YouTubeStylePlayer extends StatefulWidget {
  const YouTubeStylePlayer({super.key});

  @override
  State<YouTubeStylePlayer> createState() => _YouTubeStylePlayerState();
}

class _YouTubeStylePlayerState extends State<YouTubeStylePlayer> {
  final ScrollController _scrollController = ScrollController();
  VideoPlayerController? _controller;
  bool _isBuffering = true;
  bool _isMuted = false;

  final List<Map<String, dynamic>> allVideos = [
    {
      "id": 1,
      "title": "The Power of Meditation",
      "episode": "01",
      "posterPath":
          "https://images.unsplash.com/photo-1506126613408-eca07ce68773?q=80&w=800",
      "videoUrl":
          "https://s3.eu-west-2.amazonaws.com/lodams-videoshare/videos/h-life15_601699fe3ccc7b0007cbc451.mp4"
    },
    {
      "id": 2,
      "title": "Walking in Wisdom",
      "episode": "02",
      "posterPath":
          "https://images.unsplash.com/photo-1470770841072-f978cf4d019e?q=80&w=800",
      "videoUrl":
          "https://s3.eu-west-2.amazonaws.com/lodams-videoshare/videos/h-life15_601699fe3ccc7b0007cbc451.mp4"
    },
    {
      "id": 3,
      "title": "Divine Health Realities",
      "episode": "03",
      "posterPath":
          "https://images.unsplash.com/photo-1505533321630-975218a5f66f?q=80&w=800",
      "videoUrl":
          "https://s3.eu-west-2.amazonaws.com/lodams-videoshare/videos/h-life15_601699fe3ccc7b0007cbc451.mp4"
    }
  ];

  late Map<String, dynamic> currentVideo;

  @override
  void initState() {
    super.initState();
    currentVideo = allVideos[0];
    _initializePlayer(currentVideo['videoUrl']);
  }

  Future<void> _initializePlayer(String url) async {
    if (_controller != null) {
      _controller!.removeListener(_videoListener);
      await _controller!.pause();
      await _controller!.dispose();
      _controller = null;
    }

    if (!mounted) return;
    setState(() => _isBuffering = true);

    _controller = VideoPlayerController.networkUrl(Uri.parse(url));

    try {
      await _controller!.initialize();
      await _controller!.setVolume(_isMuted ? 0 : 1);
      _controller!.setLooping(true);
      await _controller!.play();
      _controller!.addListener(_videoListener);
    } catch (e) {
      debugPrint("Video Error: $e");
    } finally {
      if (mounted) setState(() => _isBuffering = false);
    }
  }

  void _videoListener() => setState(() {});

  void _togglePlay() {
    if (_controller == null || !_controller!.value.isInitialized) return;
    _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerHeight =
        MediaQuery.of(context).size.height * 0.45; // Defined height

    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: Column(
        // Changed from Stack to Column for better hit testing
        children: [
          // 1. Fixed Video Player Area
          SizedBox(
            height: playerHeight,
            child: _buildHeroPlayer(),
          ),

          // 2. Scrollable Content Area
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Container(
                color: const Color(0xFF050505),
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildActionRow(),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(
                          24, 40, 24, 20), // Added more top padding
                      child: Text("Archive Collection",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                    _buildVerticalSuggestions(),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroPlayer() {
    final bool isReady =
        _controller != null && _controller!.value.isInitialized;
    final bool isPlaying = isReady && _controller!.value.isPlaying;

    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onTap: _togglePlay,
          behavior:
              HitTestBehavior.opaque, // Ensures the whole area catches the tap
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(currentVideo['posterPath'], fit: BoxFit.cover),
              if (isReady)
                Center(
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                  ),
                ),
              ),
            ],
          ),
        ),

        if (_isBuffering)
          const Center(
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Color(0xFF6366F1))),

        // Metadata
        Positioned(
          bottom: 70,
          left: 24,
          right: 24,
          child: IgnorePointer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: const Color(0xFF6366F1),
                      borderRadius: BorderRadius.circular(4)),
                  child: Text("EPISODE ${currentVideo['episode']}",
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                const SizedBox(height: 8),
                Text(currentVideo['title'],
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white)),
              ],
            ),
          ),
        ),

        // Controls Area - Placed on top of the GestureDetector
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isReady)
                VideoProgressIndicator(
                  _controller!,
                  allowScrubbing: true,
                  colors: const VideoProgressColors(
                    playedColor: Color(0xFF6366F1),
                    bufferedColor: Colors.white24,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                color: Colors.black.withOpacity(0.4),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                          isPlaying ? LucideIcons.pause : LucideIcons.play,
                          color: Colors.white,
                          size: 20),
                      onPressed: _togglePlay,
                    ),
                    IconButton(
                      icon: Icon(
                          _isMuted
                              ? LucideIcons.volume_x
                              : LucideIcons.volume_2,
                          color: Colors.white,
                          size: 20),
                      onPressed: () {
                        setState(() {
                          _isMuted = !_isMuted;
                          _controller?.setVolume(_isMuted ? 0 : 1);
                        });
                      },
                    ),
                    const Spacer(),
                    if (isReady)
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(
                            _formatDuration(_controller!.value.position),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Back Button
        Positioned(
          top: 40,
          left: 16,
          child: CircleAvatar(
            backgroundColor: Colors.black26,
            child: IconButton(
              icon: const Icon(LucideIcons.arrow_left,
                  color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }

  // Formatting helper
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  Widget _buildVerticalSuggestions() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 24,
        childAspectRatio: 0.85,
      ),
      itemCount: allVideos.length,
      itemBuilder: (context, index) {
        final video = allVideos[index];
        bool isActive = video['id'] == currentVideo['id'];
        return GestureDetector(
          onTap: () {
            setState(() {
              currentVideo = video;
              _initializePlayer(video['videoUrl']);
            });
            _scrollController.animateTo(0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(video['posterPath'], fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 10),
              Text(video['title'],
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color:
                          isActive ? const Color(0xFF6366F1) : Colors.white)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _actionButton(LucideIcons.list_music, "Playlist"),
        const SizedBox(width: 40),
        _actionButton(LucideIcons.heart, "Like"),
      ],
    );
  }

  Widget _actionButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 22, color: const Color(0xFF6366F1)),
        const SizedBox(height: 8),
        Text(label,
            style: const TextStyle(fontSize: 11, color: Colors.white70)),
      ],
    );
  }
}
