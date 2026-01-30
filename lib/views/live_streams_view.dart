import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LiveStreamsView extends StatefulWidget {
  const LiveStreamsView({super.key});

  @override
  State<LiveStreamsView> createState() => _LiveStreamsViewState();
}

class _LiveStreamsViewState extends State<LiveStreamsView>
    with SingleTickerProviderStateMixin {
  late YoutubePlayerController _ytController;
  late AnimationController _pulseController;
  final Color brandColor = const Color(0xFF6366F1);
  final bool _isLoading = false; // Mock loading state for API readiness

  @override
  void initState() {
    super.initState();
    _ytController = YoutubePlayerController(
      initialVideoId: 'uD9-jNKwSa0', // Replace with dynamic ID from API
      flags:
          const YoutubePlayerFlags(autoPlay: false, isLive: true, mute: false),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ytController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: brandColor))
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildVideoPlayerSection(),
                        _buildStreamInfo(),
                        const Divider(
                            height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                        const ChatSection(),
                      ],
                    ),
                  ),
                ),
                const ChatInputSection(),
              ],
            ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(LucideIcons.chevron_left, color: Color(0xFF1E293B)),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        "LIVE BROADCAST",
        style: TextStyle(
          color: Color(0xFF1E293B),
          fontWeight: FontWeight.w800,
          fontSize: 16,
          letterSpacing: 1.2,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(LucideIcons.share_2,
              color: Color(0xFF1E293B), size: 20),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildVideoPlayerSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: YoutubePlayer(
          controller: _ytController,
          progressIndicatorColor: brandColor,
          liveUIColor: Colors.red,
        ),
      ),
    );
  }

  Widget _buildStreamInfo() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildLiveBadge(),
              const SizedBox(width: 12),
              _buildViewerCounter("1,420"),
              const Spacer(),
              _buildSupportButton(),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Sunday Special: The Power of Persistent Prayer",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: brandColor.withOpacity(0.3), width: 2),
                ),
                child: const CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(0xFFE2E8F0),
                  child: Icon(LucideIcons.user,
                      size: 16, color: Color(0xFF64748B)),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "Pastor Deola Phillips",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLiveBadge() {
    return ScaleTransition(
      scale: Tween(begin: 0.95, end: 1.05).animate(_pulseController),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Row(
          children: [
            Icon(Icons.circle, color: Colors.white, size: 8),
            SizedBox(width: 6),
            Text("LIVE",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildViewerCounter(String count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.users, color: Color(0xFF64748B), size: 14),
          const SizedBox(width: 6),
          Text(count,
              style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w700,
                  fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSupportButton() {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(LucideIcons.heart, size: 16),
      label: const Text("SUPPORT"),
      style: ElevatedButton.styleFrom(
        backgroundColor: brandColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
      ),
    );
  }
}

class ChatSection extends StatelessWidget {
  const ChatSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(LucideIcons.message_square,
                  size: 18, color: Color(0xFF1E293B)),
              SizedBox(width: 8),
              Text("Live Community",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Color(0xFF1E293B))),
            ],
          ),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 8, // Connect to API Stream
            itemBuilder: (context, index) => _buildChatBubble(index),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(int i) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=$i"),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Faith Member $i",
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF64748B))),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                  ),
                  child: const Text(
                    "God is indeed faithful! Receiving this word from Lagos. 🙏✨",
                    style: TextStyle(
                        fontSize: 14, color: Color(0xFF334155), height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatInputSection extends StatefulWidget {
  const ChatInputSection({super.key});

  @override
  State<ChatInputSection> createState() => _ChatInputSectionState();
}

class _ChatInputSectionState extends State<ChatInputSection> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _quickEmojis = ["🙏", "🔥", "🙌", "❤️", "✨", "👏"];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 10, top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5))
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _quickEmojis.length,
              itemBuilder: (context, i) => GestureDetector(
                onTap: () => _messageController.text += _quickEmojis[i],
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(20)),
                  alignment: Alignment.center,
                  child: Text(_quickEmojis[i],
                      style: const TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Join the conversation...",
                      hintStyle: const TextStyle(
                          color: Color(0xFF94A3B8), fontSize: 14),
                      filled: true,
                      fillColor: const Color(0xFFF1F5F9),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    // API Call: sendMessage(_messageController.text);
                    _messageController.clear();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                        color: Color(0xFF6366F1), shape: BoxShape.circle),
                    child: const Icon(LucideIcons.send,
                        color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
