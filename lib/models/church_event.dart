class ChurchEvent {
  final String id;
  final String title;
  final String date;
  final String time;
  final String image;
  final String description;
  final bool isLive;

  ChurchEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.image,
    required this.description,
    this.isLive = false,
  });

  factory ChurchEvent.fromJson(Map<String, dynamic> json) {
    return ChurchEvent(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Untitled Event',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      image: json['image'] ?? 'https://via.placeholder.com/800',
      description: json['desc'] ?? '',
      isLive: json['isLive'] ?? false,
    );
  }
}
