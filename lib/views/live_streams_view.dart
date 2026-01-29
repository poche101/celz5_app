import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LiveStreamsView extends StatefulWidget {
  const LiveStreamsView({super.key});

  @override
  State<LiveStreamsView> createState() => _LiveStreamsViewState();
}

class _LiveStreamsViewState extends State<LiveStreamsView> {
  late YoutubePlayerController _controller;
  final Color brandColor = const Color(0xFF6366F1);

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'uD9-jNKwSa0',
      flags: const YoutubePlayerFlags(autoPlay: false, isLive: true),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isDesktop = size.width > 1100;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF0F172A),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: isDesktop ? 40 : 16),
                  child:
                      isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(LucideIcons.chevron_left,
                  color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              "LIVE BROADCAST",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 7,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: _buildPlayerSection(),
          ),
        ),
        const SizedBox(width: 32),
        const Expanded(flex: 3, child: ChatSection(isScrollable: true)),
      ],
    );
  }

  Widget _buildMobileLayout() {
    // Added SingleChildScrollView so the whole page scrolls on mobile
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildPlayerSection(),
          const SizedBox(height: 24),
          const ChatSection(
              isScrollable: false), // Disable inner scroll to allow page scroll
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPlayerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 40,
                offset: const Offset(0, 20),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubePlayer(
                controller: _controller,
                progressIndicatorColor: brandColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const LiveBadge(),
            const ViewerCount(count: "1,420"),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(LucideIcons.heart, size: 16, color: brandColor),
              label: Text("Support",
                  style: TextStyle(color: brandColor, fontSize: 13)),
              style: TextButton.styleFrom(
                backgroundColor: brandColor.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            )
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          "Sunday Special: The Power of Persistent Prayer",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const CircleAvatar(radius: 10, backgroundColor: Colors.blueGrey),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "With Pastor Deola Phillips",
                style: TextStyle(
                  color: const Color(0xFF94A3B8).withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// --- SUPPORTING COMPONENTS ---

class ChatSection extends StatelessWidget {
  final bool isScrollable;
  const ChatSection({super.key, this.isScrollable = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Important for the scroll view
        children: [
          _buildHeader(),
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 15,
            shrinkWrap: true, // Necessary when inside a SingleChildScrollView
            physics: isScrollable
                ? const BouncingScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) => _buildChatItem(i),
          ),
          const ChatInputSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(LucideIcons.message_circle, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          const Text("Live Chat",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const Spacer(),
          const CircleAvatar(radius: 3, backgroundColor: Colors.green),
          const SizedBox(width: 6),
          Text("1.2k",
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildChatItem(int i) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=$i"),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("User_$i",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                const Text("Amen! This is such a blessing. 🙏🔥",
                    style: TextStyle(color: Colors.white, fontSize: 13)),
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
  final TextEditingController _controller = TextEditingController();
  final List<String> _emojis = ["🙏", "🙌", "🔥", "❤️", "✨", "👏", "🎯", "👑"];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 32,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _emojis.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => _controller.text += _emojis[index],
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(_emojis[index],
                      style: const TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: "Say something...",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                suffixIcon: IconButton(
                  icon: const Icon(LucideIcons.send,
                      color: Color(0xFF6366F1), size: 18),
                  onPressed: () => _controller.clear(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LiveBadge extends StatelessWidget {
  const LiveBadge({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(6)),
      child: const Text("LIVE",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
    );
  }
}

class ViewerCount extends StatelessWidget {
  final String count;
  const ViewerCount({super.key, required this.count});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(LucideIcons.users, color: Colors.white.withOpacity(0.5), size: 14),
        const SizedBox(width: 4),
        Text(count,
            style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}
