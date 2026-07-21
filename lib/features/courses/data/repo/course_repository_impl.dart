import 'dart:convert';
import 'package:almentor_course_player/features/courses/data/repo/course_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/course_model.dart';

class CourseRepositoryImpl implements CourseRepository {
  final SharedPreferences prefs;

  CourseRepositoryImpl(this.prefs);

  final String _mockJsonResponse = '''
  {
   "courses": [
     {
       "id": "c001",
       "title": "Intro to UI/UX Design",
       "thumbnailUrl": "https://picsum.photos/seed/course1/400/225",
       "durationSeconds": 30,
       "description": "A short primer on UI/UX fundamentals.",
       "videoUrl": "https://cdn.pixabay.com/video/2026/07/10/363199_large.mp4"
     },
     {
       "id": "c002",
       "title": "Digital Marketing Basics",
       "thumbnailUrl": "https://picsum.photos/seed/course2/400/225",
       "durationSeconds": 30,
       "description": "Core concepts every digital marketer should know.",
       "videoUrl": "https://cdn.pixabay.com/video/2026/03/31/343478_large.mp4"
     }
   ]
  }
  ''';

  @override
  Future<List<CourseModel>> loadCourses() async {
    final Map<String, dynamic> jsonMap = jsonDecode(_mockJsonResponse);
    final List<dynamic> list = jsonMap['courses'];

    List<CourseModel> courses = list
        .map((e) => CourseModel.fromJson(e))
        .toList();

    for (int i = 0; i < courses.length; i++) {
      final id = courses[i].id;
      final savedPos = prefs.getInt('${id}_pos') ?? 0;
      final savedProg = prefs.getDouble('${id}_prog') ?? 0.0;

      courses[i] = courses[i].copyWith(
        lastPosition: savedPos,
        progress: savedProg,
      );
    }
    return courses;
  }

  @override
  Future<void> saveCourseProgress(
    String id,
    int position,
    double progress,
  ) async {
    await prefs.setInt('${id}_pos', position);
    await prefs.setDouble('${id}_prog', progress);
  }
}
