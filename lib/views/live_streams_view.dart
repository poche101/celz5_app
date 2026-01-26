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

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'uD9-jNKwSa0',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        isLive: true,
        mute: false,
      ),
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
    final bool isDesktop = size.width > 1000;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.blueAccent),
        centerTitle: false,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 40 : 20,
                vertical: 12,
              ),
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: _buildMainContent()),
                        const SizedBox(width: 24),
                        const Expanded(
                          flex: 3,
                          child: ChatSection(maxHeight: 700),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        _buildMainContent(),
                        const SizedBox(height: 24),
                        const ChatSection(maxHeight: 500),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.blueAccent,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Row(
          children: [
            LiveBadge(),
            SizedBox(width: 12),
            ViewerCount(count: "1,420"),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          "Sunday Special: The Power of Persistent Prayer",
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "With Pastor Deola Phillips",
          style: TextStyle(
            color: Color(0xFF64748B),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        const Divider(color: Color(0xFFF1F5F9), thickness: 2),
      ],
    );
  }
}

// --- CHAT SECTION ---

class ChatSection extends StatelessWidget {
  final double maxHeight;
  const ChatSection({super.key, required this.maxHeight});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Container(
        // Added clipBehavior to ensure header background follows border radius
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 15,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            const ChatHeader(), // Header with Home Menu background
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 15,
                itemBuilder: (context, i) => ChatBubble(index: i),
              ),
            ),
            const ChatInput(),
          ],
        ),
      ),
    );
  }
}

class ChatHeader extends StatelessWidget {
  const ChatHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      // Background matches Home Menu (Slate Dark)
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
      ),
      child: const Row(
        children: [
          Icon(LucideIcons.message_circle, color: Colors.blueAccent, size: 20),
          SizedBox(width: 10),
          Text(
            "Live Community",
            style: TextStyle(
              color: Colors.white, // Text is now white
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          Spacer(),
          // Small active "Live" indicator
          CircleAvatar(radius: 4, backgroundColor: Colors.green),
        ],
      ),
    );
  }
}

class ChatInput extends StatefulWidget {
  const ChatInput({super.key});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _textController = TextEditingController();
  bool _showEmojiPicker = false;

  final List<String> _quickEmojis = [
    "🙏",
    "🙌",
    "🔥",
    "❤️",
    "🎯",
    "👑",
    "✨",
    "👏",
    "✅",
    "🌟"
  ];

  void _insertEmoji(String emoji) {
    final text = _textController.text;
    final selection = _textController.selection;
    final newText = text.replaceRange(selection.start, selection.end, emoji);
    final startIndex = selection.start + emoji.length;

    setState(() {
      _textController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: startIndex),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: _showEmojiPicker ? 50 : 0,
          decoration: const BoxDecoration(
            color: Color(0xFFF8FAFC),
            border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
          ),
          child: _showEmojiPicker
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: _quickEmojis.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => _insertEmoji(_quickEmojis[index]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Center(
                          child: Text(_quickEmojis[index],
                              style: const TextStyle(fontSize: 20)),
                        ),
                      ),
                    );
                  },
                )
              : const SizedBox.shrink(),
        ),
        const Divider(height: 1, color: Color(0xFFF1F5F9)),
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _textController,
            onTap: () {
              if (_showEmojiPicker) setState(() => _showEmojiPicker = false);
            },
            style: const TextStyle(
                color: Color(0xFF1E293B), fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: "Join the conversation...",
              hintStyle:
                  const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              prefixIcon: IconButton(
                icon: Icon(
                  _showEmojiPicker ? LucideIcons.keyboard : LucideIcons.smile,
                  color: _showEmojiPicker
                      ? Colors.blueAccent
                      : const Color(0xFF64748B),
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _showEmojiPicker = !_showEmojiPicker),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: const Icon(LucideIcons.send,
                    color: Colors.blueAccent, size: 18),
                onPressed: () {
                  _textController.clear();
                  if (_showEmojiPicker)
                    setState(() => _showEmojiPicker = false);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// --- COMPONENTS ---

class LiveBadge extends StatelessWidget {
  const LiveBadge({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(6)),
      child: const Text("LIVE",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 11,
              letterSpacing: 1)),
    );
  }
}

class ViewerCount extends StatelessWidget {
  final String count;
  const ViewerCount({super.key, required this.count});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(LucideIcons.users, color: Color(0xFF64748B), size: 16),
        const SizedBox(width: 6),
        Text(count,
            style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 13,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class ChatBubble extends StatelessWidget {
  final int index;
  const ChatBubble({super.key, required this.index});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=$index"),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Member ${index + 1}",
                    style: const TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12)
                        .copyWith(topLeft: Radius.zero),
                  ),
                  child: const Text("God is faithful! Amen. 🙌",
                      style: TextStyle(
                          color: Color(0xFF334155), fontSize: 13, height: 1.4)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
