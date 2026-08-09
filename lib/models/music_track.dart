import 'dart:convert';

class MusicTrack {
  final String id;
  final String title;
  final String category; // "موسيقى تصويرية", "مؤثرات صوتية", "ترانيم وألحان"
  final String duration;
  final String audioUrl;
  final String composer;

  MusicTrack({
    required this.id,
    required this.title,
    required this.category,
    required this.duration,
    required this.audioUrl,
    required this.composer,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'duration': duration,
      'audioUrl': audioUrl,
      'composer': composer,
    };
  }

  factory MusicTrack.fromMap(Map<String, dynamic> map) {
    return MusicTrack(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      category: map['category'] ?? 'موسيقى تصويرية',
      duration: map['duration'] ?? '03:45',
      audioUrl: map['audioUrl'] ?? '',
      composer: map['composer'] ?? 'فريق الكورال والمسرح',
    );
  }

  String toJson() => json.encode(toMap());

  factory MusicTrack.fromJson(String source) => MusicTrack.fromMap(json.decode(source));
}
