class TestimonyModel {
  final String id;
  final String type; // 'video' or 'text'
  final String fullName;
  final String content;
  final String? church;
  final String? thumbnailUrl;
  final String? videoUrl;

  TestimonyModel({
    required this.id,
    required this.type,
    required this.fullName,
    required this.content,
    this.church,
    this.thumbnailUrl,
    this.videoUrl,
  });

  factory TestimonyModel.fromJson(Map<String, dynamic> json) {
    return TestimonyModel(
      id: json['id']?.toString() ?? '',
      type: json['type'] ?? 'text',
      fullName: json['full_name'] ?? 'Anonymous',
      content: json['content'] ?? '',
      church: json['church'],
      thumbnailUrl: json['thumbnail_url'],
      videoUrl: json['video_url'],
    );
  }
}
