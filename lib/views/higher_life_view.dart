import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../models/video_model.dart';
// The Robust Way (Package Imports)
import 'package:celz5_app/services/video_controller.dart';
import 'package:celz5_app/core/constants/api_constants.dart';

class HigherLifeArchiveApp extends StatelessWidget {
  const HigherLifeArchiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF050505),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          primary: const Color(0xFF6366F1),
        ),
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
  final VideoController _videoController = VideoController();
  final ScrollController _scrollController = ScrollController();

  List<VideoModel> allVideos = [];
  VideoModel? currentVideo;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  // Fetch data from Laravel API
  Future<void> _loadInitialData() async {
    try {
      final videos = await _videoController.fetchVideos();
      setState(() {
        allVideos = videos;
        if (videos.isNotEmpty) {
          currentVideo = videos[0];
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Could not load archive. Check your connection.";
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(body: Center(child: Text(_errorMessage!)));
    }

    return Scaffold(
      body: Stack(
        children: [
          // Hero Player Section
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.55,
            child: _buildHeroPlayer(),
          ),

          Positioned.fill(
            child: RefreshIndicator(
              onRefresh: _loadInitialData,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.50),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(32)),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildActionRow(),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(24, 32, 24, 20),
                            child: Text("Archive Collection",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                          ),
                          _buildVerticalSuggestions(),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Back Button
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.black45,
              child: IconButton(
                icon: const Icon(LucideIcons.arrow_left,
                    color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroPlayer() {
    if (currentVideo == null) return const SizedBox();

    return Stack(
      fit: StackFit.expand,
      children: [
        // Combine Base URL with stored path
        Image.network(
          "${ApiConstants.storageBaseUrl}${currentVideo!.posterPath}",
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Container(color: Colors.grey[900]),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
            ),
          ),
        ),
        const Center(
            child: Icon(LucideIcons.circle_play,
                size: 70, color: Color(0xFF6366F1))),
        Positioned(
          bottom: 60,
          left: 24,
          right: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text("EPISODE ${currentVideo!.episode}",
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              Text(currentVideo!.title,
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.w900, height: 1.2)),
              const SizedBox(height: 8),
              Text(currentVideo!.description ?? "NO DESCRIPTION AVAILABLE",
                  style: const TextStyle(color: Colors.white60, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  // Action row and vertical suggestion builders stay similar,
  // just update them to use VideoModel fields (title, posterPath, etc.)
  Widget _buildVerticalSuggestions() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            2, // Changed to 2 for better visibility of network images
        crossAxisSpacing: 16,
        mainAxisSpacing: 24,
        childAspectRatio: 0.85,
      ),
      itemCount: allVideos.length,
      itemBuilder: (context, index) {
        final video = allVideos[index];
        bool isPlaying = video.id == currentVideo?.id;

        return GestureDetector(
          onTap: () {
            setState(() => currentVideo = video);
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
                  child: Image.network(
                    "${ApiConstants.storageBaseUrl}${video.posterPath}",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(video.title,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color:
                          isPlaying ? const Color(0xFF6366F1) : Colors.white)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _actionButton(LucideIcons.list_music, "Playlist"),
          _actionButton(LucideIcons.heart, "Like"),
        ],
      ),
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
