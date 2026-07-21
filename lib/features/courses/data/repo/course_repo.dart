import '../models/course_model.dart';

abstract class CourseRepository {
  Future<List<CourseModel>> loadCourses();
  Future<void> saveCourseProgress(String id, int position, double progress);
}
