class CourseModel {
  final String id;
  final String title;
  final String thumbnailUrl;
  final int durationSeconds;
  final String description;
  final String videoUrl;
  final double progress;
  final int lastPosition;

  CourseModel({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.durationSeconds,
    required this.description,
    required this.videoUrl,
    this.progress = 0.0,
    this.lastPosition = 0,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
      durationSeconds: json['durationSeconds'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      videoUrl: json['videoUrl'] as String? ?? '',
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      lastPosition: json['lastPosition'] as int? ?? 0,
    );
  }

  CourseModel copyWith({double? progress, int? lastPosition}) {
    return CourseModel(
      id: id,
      title: title,
      thumbnailUrl: thumbnailUrl,
      durationSeconds: durationSeconds,
      description: description,
      videoUrl: videoUrl,
      progress: progress ?? this.progress,
      lastPosition: lastPosition ?? this.lastPosition,
    );
  }
}
