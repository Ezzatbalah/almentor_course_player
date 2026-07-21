import 'dart:convert';
import 'package:almentor_course_player/features/courses/data/repo/course_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/course_model.dart';

class CourseRepositoryImpl implements CourseRepository {
  final SharedPreferences prefs;

  CourseRepositoryImpl(this.prefs);

  final String _mockData = '''
  {
    "courses": [
      {
        "id": "c001",
        "title": "Intro to UI/UX Design",
        "thumbnailUrl": "https://picsum.photos/seed/course1/400/225",
        "durationSeconds": 30,
        "description": "A short primer on UI/UX fundamentals and user-centered design paradigms.",
        "videoUrl": "https://cdn.pixabay.com/video/2026/07/10/363199_large.mp4"
      },
      {
        "id": "c002",
        "title": "Digital Marketing Basics",
        "thumbnailUrl": "https://picsum.photos/seed/course2/400/225",
        "durationSeconds": 30,
        "description": "Core concepts every digital marketer should know to scale projects.",
        "videoUrl": "https://cdn.pixabay.com/video/2026/03/31/343478_large.mp4"
      },
      {
        "id": "c003",
        "title": "Public Speaking Confidence",
        "thumbnailUrl": "https://picsum.photos/seed/course3/400/225",
        "durationSeconds": 30,
        "description": "Practical tips to speak with confidence and handle presentation anxiety.",
        "videoUrl": "https://cdn.pixabay.com/video/2026/07/01/361729_large.mp4"
      }
    ]
  }
  ''';

  @override
  Future<List<CourseModel>> fetchCourses() async {
    final Map<String, dynamic> decodedJson = jsonDecode(_mockData);
    final List<dynamic> courseList = decodedJson['courses'];

    List<CourseModel> courses = courseList
        .map((e) => CourseModel.fromJson(e))
        .toList();

    for (int i = 0; i < courses.length; i++) {
      final id = courses[i].id;
      final savedPos = prefs.getInt('${id}_position') ?? 0;
      final savedProgress = prefs.getDouble('${id}_progress') ?? 0.0;

      courses[i] = courses[i].copyWith(
        lastPosition: savedPos,
        progress: savedProgress,
      );
    }

    return courses;
  }

  @override
  Future<void> saveProgress({
    required String courseId,
    required int position,
    required double progress,
  }) async {
    await prefs.setInt('${courseId}_position', position);
    await prefs.setDouble('${courseId}_progress', progress);
  }
}
