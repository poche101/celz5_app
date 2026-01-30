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

  // This converts the Map from your API/Mock data into a VideoModel object
  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown Title',
      episode: json['episode']?.toString() ?? '0',
      posterPath: json['posterPath'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
    );
  }
}
