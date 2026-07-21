import '../models/course_model.dart';

abstract class CourseRepository {
  Future<List<CourseModel>> fetchCourses();
  Future<void> saveProgress({
    required String courseId,
    required int position,
    required double progress,
  });
}
