import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:celz5_app/views/home_view.dart';

void main() => runApp(const HigherLifeArchiveApp());

class VideoMessage {
  final String title;
  final String thumbnail;
  final String videoUrl;
  final String duration;
  final int episode;

  VideoMessage({
    required this.title,
    required this.thumbnail,
    required this.videoUrl,
    required this.duration,
    required this.episode,
  });
}

class HigherLifeArchiveApp extends StatelessWidget {
  const HigherLifeArchiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Define your routes here
      routes: {'/home': (context) => const HomeView()},
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
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  final List<VideoMessage> allVideos = [
    VideoMessage(
        title: "The Excellence of the Spirit",
        thumbnail:
            "https://images.unsplash.com/photo-1507692049790-de58290a4334?q=80&w=2070",
        videoUrl: "vid1",
        duration: "45:10",
        episode: 1),
    VideoMessage(
        title: "Walking in Spiritual Authority",
        thumbnail:
            "https://images.unsplash.com/photo-1460925895917-afdab827c52f?q=80&w=2426",
        videoUrl: "vid2",
        duration: "14:20",
        episode: 2),
    VideoMessage(
        title: "The Power of Intercession",
        thumbnail:
            "https://images.unsplash.com/photo-1518709268805-4e9042af9f23?q=80&w=2070",
        videoUrl: "vid3",
        duration: "32:45",
        episode: 3),
    VideoMessage(
        title: "Spiritual Growth Secrets",
        thumbnail:
            "https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?q=80&w=2070",
        videoUrl: "vid4",
        duration: "55:00",
        episode: 4),
    VideoMessage(
        title: "Divine Guidance",
        thumbnail:
            "https://images.unsplash.com/photo-1493612276216-ee3925520721?q=80&w=2070",
        videoUrl: "vid5",
        duration: "28:15",
        episode: 5),
  ];

  late VideoMessage currentVideo;

  @override
  void initState() {
    super.initState();
    currentVideo = allVideos[0];
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore) {
        _loadMoreVideos();
      }
    }
  }

  Future<void> _loadMoreVideos() async {
    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(seconds: 2));

    final List<VideoMessage> nextBatch = [
      VideoMessage(
          title: "Living by the Word",
          thumbnail:
              "https://images.unsplash.com/photo-1504052434569-70ad5836ab65?q=80&w=2070",
          videoUrl: "vid${allVideos.length + 1}",
          duration: "40:00",
          episode: allVideos.length + 1),
      VideoMessage(
          title: "The Heart of Worship",
          thumbnail:
              "https://images.unsplash.com/photo-1499364615650-ec38552f4f34?q=80&w=2070",
          videoUrl: "vid${allVideos.length + 2}",
          duration: "35:20",
          episode: allVideos.length + 2),
      VideoMessage(
          title: "Faith in Action",
          thumbnail:
              "https://images.unsplash.com/photo-1519389950473-47ba0277781c?q=80&w=2070",
          videoUrl: "vid${allVideos.length + 3}",
          duration: "50:10",
          episode: allVideos.length + 3),
      VideoMessage(
          title: "Abiding in Rest",
          thumbnail:
              "https://images.unsplash.com/photo-1470252649358-9c9e6c73f082?q=80&w=2070",
          videoUrl: "vid${allVideos.length + 4}",
          duration: "22:45",
          episode: allVideos.length + 4),
    ];

    setState(() {
      allVideos.addAll(nextBatch);
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.55,
            child: _buildHeroPlayer(),
          ),
          Positioned.fill(
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
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(32)),
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
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5)),
                        ),
                        _buildVerticalSuggestions(),
                        if (_isLoadingMore)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 2)),
                          ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- UPDATED BACK BUTTON ---
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.black45,
              child: IconButton(
                icon: const Icon(LucideIcons.arrow_left,
                    color: Colors.white, size: 20),
                onPressed: () {
                  // This redirects specifically to the home route
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/home', (route) => false);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroPlayer() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(currentVideo.thumbnail, fit: BoxFit.cover),
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
          child:
              Icon(LucideIcons.circle_play, size: 70, color: Color(0xFF6366F1)),
        ),
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
                child: Text("EPISODE ${currentVideo.episode}",
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              Text(currentVideo.title,
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.w900, height: 1.2)),
              const SizedBox(height: 8),
              const Text("WATCH THE HIGHER LIFE",
                  style: TextStyle(
                      color: Colors.white60,
                      letterSpacing: 2,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
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

  Widget _buildVerticalSuggestions() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 24,
        childAspectRatio: 0.85,
      ),
      itemCount: allVideos.length,
      itemBuilder: (context, index) {
        final video = allVideos[index];
        bool isPlaying = video.videoUrl == currentVideo.videoUrl;

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
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(video.thumbnail, fit: BoxFit.cover),
                      if (isPlaying)
                        Container(
                          color: const Color(0xFF6366F1).withOpacity(0.6),
                          child: const Icon(LucideIcons.play,
                              size: 24, color: Colors.white),
                        ),
                      Positioned(
                        bottom: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(4)),
                          child: Text(video.duration,
                              style: const TextStyle(
                                  fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                video.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: isPlaying ? FontWeight.bold : FontWeight.w600,
                    color: isPlaying ? const Color(0xFF6366F1) : Colors.white),
              ),
              Text("Ep ${video.episode}",
                  style: const TextStyle(fontSize: 11, color: Colors.white38)),
            ],
          ),
        );
      },
    );
  }
}
