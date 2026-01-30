import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

// --- DATA MODEL ---
class VideoModel {
  final int id;
  final String title;
  final String episode;
  final String posterPath;
  final String videoUrl;

  VideoModel({
    required this.id,
    required this.title,
    required this.episode,
    required this.posterPath,
    required this.videoUrl,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Untitled',
      episode: json['episode']?.toString() ?? '0',
      posterPath: json['posterPath'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
    );
  }
}

// --- API SERVICE ---
class VideoService {
  Future<List<VideoModel>> fetchVideos({int page = 1}) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    final List<Map<String, dynamic>> mockData = [
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
    return mockData.map((v) => VideoModel.fromJson(v)).toList();
  }
}

class HigherLifeArchiveApp extends StatelessWidget {
  const HigherLifeArchiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      home: const YouTubeStylePlayer(),
    );
  }
}

class YouTubeStylePlayer extends StatefulWidget {
  const YouTubeStylePlayer({super.key});

  @override
  State<YouTubeStylePlayer> createState() => _YouTubeStylePlayerState();
}

class _YouTubeStylePlayerState extends State<YouTubeStylePlayer> {
  final VideoService _videoService = VideoService();
  final List<VideoModel> _allVideos = [];
  VideoModel? _currentVideo;

  VideoPlayerController? _controller;
  bool _isLoading = true;
  bool _isBuffering = true;
  bool _isMuted = false;
  bool _showTitle = true;
  Timer? _titleTimer;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final videos = await _videoService.fetchVideos();
      if (mounted) {
        setState(() {
          _allVideos.addAll(videos);
          if (_allVideos.isNotEmpty) {
            _currentVideo = _allVideos[0];
            _initializePlayer(_currentVideo!.videoUrl);
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("API Error: $e");
    }
  }

  Future<void> _initializePlayer(String url) async {
    if (_controller != null) {
      await _controller!.pause();
      await _controller!.dispose();
    }

    setState(() {
      _isBuffering = true;
      _showTitle = true;
    });

    _startTitleTimer();
    _controller = VideoPlayerController.networkUrl(Uri.parse(url));

    try {
      await _controller!.initialize();
      _controller!.setVolume(_isMuted ? 0 : 1);
      _controller!.setLooping(true);
      await _controller!.play();
      _controller!.addListener(() => setState(() {}));
    } catch (e) {
      debugPrint("Video Error: $e");
    } finally {
      if (mounted) setState(() => _isBuffering = false);
    }
  }

  void _startTitleTimer() {
    _titleTimer?.cancel();
    _titleTimer = Timer(const Duration(minutes: 1), () {
      if (mounted) setState(() => _showTitle = false);
    });
  }

  void _togglePlay() {
    if (_controller == null || !_controller!.value.isInitialized) return;
    _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
    setState(() {});
  }

  @override
  void dispose() {
    _titleTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
          body: Center(
              child: CircularProgressIndicator(color: Color(0xFF6366F1))));
    }

    final playerHeight = MediaQuery.of(context).size.height * 0.40;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          Container(
            height: playerHeight,
            color: Colors.black,
            child: _buildHeroPlayer(),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
                  child: Text(
                    "Archive Collection",
                    style: const TextStyle(
                      fontSize: 32, // Standard Mobile Headline
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                _buildVerticalSuggestions(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroPlayer() {
    if (_currentVideo == null) return const SizedBox.shrink();
    final bool isReady = _controller?.value.isInitialized ?? false;

    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onTap: _togglePlay,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(_currentVideo!.posterPath, fit: BoxFit.cover),
              if (isReady)
                Center(
                    child: AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!))),
              Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.black.withOpacity(0.8)
                  ]))),
            ],
          ),
        ),
        if (_isBuffering)
          const Center(child: CircularProgressIndicator(color: Colors.white)),

        // Metadata Overlay
        AnimatedOpacity(
          opacity: _showTitle ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 800),
          child: Positioned(
            bottom: 85,
            left: 24,
            right: 24,
            child: Text(
              _currentVideo!.title,
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 10, color: Colors.black54)]),
            ),
          ),
        ),

        // Controls
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            children: [
              if (isReady)
                VideoProgressIndicator(_controller!,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                        playedColor: Color(0xFF6366F1))),
              _buildControlBar(isReady),
            ],
          ),
        ),

        // Back Button
        Positioned(
            top: 50,
            left: 20,
            child: _buildCircleIconButton(
                LucideIcons.arrow_left, () => Navigator.maybePop(context))),
      ],
    );
  }

  Widget _buildControlBar(bool isReady) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
              icon: Icon(
                  _controller?.value.isPlaying ?? false
                      ? LucideIcons.pause
                      : LucideIcons.play,
                  color: Colors.white,
                  size: 28),
              onPressed: _togglePlay),
          IconButton(
              icon: Icon(_isMuted ? LucideIcons.volume_x : LucideIcons.volume_2,
                  color: Colors.white, size: 24),
              onPressed: () {
                setState(() {
                  _isMuted = !_isMuted;
                  _controller?.setVolume(_isMuted ? 0 : 1);
                });
              }),
          const Spacer(),
          if (isReady)
            Text(_formatDuration(_controller!.value.position),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildVerticalSuggestions() {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _allVideos.length,
      itemBuilder: (context, index) {
        final video = _allVideos[index];
        final bool isActive = video.id == _currentVideo?.id;

        return GestureDetector(
          onTap: () {
            setState(() => _currentVideo = video);
            _initializePlayer(video.videoUrl);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color:
                      isActive ? const Color(0xFF6366F1) : Colors.transparent,
                  width: 2),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(video.posterPath,
                        width: 100, height: 70, fit: BoxFit.cover)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Episode ${video.episode}",
                          style: const TextStyle(
                              color: Color(0xFF6366F1),
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                      Text(video.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFF1E293B))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCircleIconButton(IconData icon, VoidCallback onTap) {
    return ClipOval(
        child: Material(
            color: Colors.black26,
            child: IconButton(
                icon: Icon(icon, color: Colors.white, size: 24),
                onPressed: onTap)));
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }
}
