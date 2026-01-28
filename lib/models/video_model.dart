class VideoModel {
  final int? id;
  final String title;
  final int episode;
  final String duration;
  final String? description;
  final String posterPath;
  final String videoPath;

  VideoModel({
    this.id,
    required this.title,
    required this.episode,
    required this.duration,
    this.description,
    required this.posterPath,
    required this.videoPath,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      title: json['title'] ?? '',
      episode: json['episode'] ?? 0,
      duration: json['duration'] ?? '',
      description: json['description'],
      // Laravel returns relative paths or full URLs depending on your Model Accessors
      posterPath: json['poster_path'] ?? '',
      videoPath: json['video_path'] ?? '',
    );
  }
}
