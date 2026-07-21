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

  static List<CourseModel> get mockCourses => [
    CourseModel(
      id: "c001",
      title: "Intro to UI/UX Design",
      thumbnailUrl: "https://picsum.photos/seed/course1/400/225",
      durationSeconds: 30,
      description:
          "A short primer on UI/UX fundamentals and user-centered design paradigms.",
      videoUrl: "https://cdn.pixabay.com/video/2026/07/10/363199_large.mp4",
      progress: 40.0,
      lastPosition: 12,
    ),
    CourseModel(
      id: "c002",
      title: "Digital Marketing Basics",
      thumbnailUrl: "https://picsum.photos/seed/course2/400/225",
      durationSeconds: 30,
      description:
          "Core concepts every digital marketer should know to scale projects.",
      videoUrl: "https://cdn.pixabay.com/video/2026/03/31/343478_large.mp4",
      progress: 10.0,
      lastPosition: 3,
    ),
  ];
}
