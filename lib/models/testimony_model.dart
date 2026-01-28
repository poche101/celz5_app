class Testimony {
  final int id;
  final String fullName;
  final String churchGroup;
  final String content;
  final String type;
  final String? videoUrl;
  final String? thumbnailUrl;
  final bool isApproved;
  final DateTime createdAt;

  Testimony({
    required this.id,
    required this.fullName,
    required this.churchGroup,
    required this.content,
    required this.type,
    this.videoUrl,
    this.thumbnailUrl,
    required this.isApproved,
    required this.createdAt,
  });

  factory Testimony.fromJson(Map<String, dynamic> json) {
    return Testimony(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? 'Anonymous',
      churchGroup: json['church_group'] ?? 'General',
      content: json['content'] ?? '',
      type: json['type'] ?? 'text',
      videoUrl: json['video_url'],
      thumbnailUrl: json['thumbnail_url'],
      // Handles 1/0 from database or true/false from JSON
      isApproved: json['is_approved'] == 1 || json['is_approved'] == true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'church_group': churchGroup,
      'content': content,
      'type': type,
    };
  }
}
