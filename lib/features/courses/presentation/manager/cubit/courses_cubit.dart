import 'package:almentor_course_player/features/courses/data/models/course_model.dart';
import 'package:almentor_course_player/features/courses/data/repo/course_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'courses_state.dart';

class CoursesCubit extends Cubit<CoursesState> {
  final CourseRepository repository;

  CoursesCubit(this.repository) : super(CoursesInitial());

  List<CourseModel> _coursesList = [];

  Future<void> getCourses() async {
    emit(CoursesLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _coursesList = await repository.fetchCourses();
      emit(CoursesLoaded(List.from(_coursesList)));
    } catch (e) {
      emit(CoursesError("Failed to load courses data."));
    }
  }

  void updateCourseProgress({
    required String courseId,
    required int currentPositionSeconds,
    required int totalDurationSeconds,
  }) {
    if (totalDurationSeconds <= 0) return;

    double calculatedProgress =
        (currentPositionSeconds / totalDurationSeconds) * 100;
    if (calculatedProgress > 100) calculatedProgress = 100;

    repository.saveProgress(
      courseId: courseId,
      position: currentPositionSeconds,
      progress: calculatedProgress,
    );

    _coursesList = _coursesList.map((course) {
      if (course.id == courseId) {
        return course.copyWith(
          lastPosition: currentPositionSeconds,
          progress: calculatedProgress,
        );
      }
      return course;
    }).toList();

    emit(CoursesLoaded(List.from(_coursesList)));
  }
}
