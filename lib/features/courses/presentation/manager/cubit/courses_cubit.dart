// ignore_for_file: depend_on_referenced_packages

import 'package:almentor_course_player/features/courses/data/models/course_model.dart';
import 'package:almentor_course_player/features/courses/data/repo/course_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'courses_state.dart';

class CoursesCubit extends Cubit<CoursesState> {
  final CourseRepository repository;

  CoursesCubit(this.repository) : super(CoursesInitial());

  List<CourseModel> _cachedList = [];

  Future<void> fetchCourses() async {
    emit(CoursesLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _cachedList = await repository.loadCourses();
      emit(CoursesLoaded(List.from(_cachedList)));
    } catch (e) {
      emit(CoursesError("Failed to fetch courses."));
    }
  }

  void updatePlaybackProgress({
    required String courseId,
    required int positionSeconds,
    required int totalDurationSeconds,
  }) {
    if (totalDurationSeconds == 0) return;

    double calculatedProgress = (positionSeconds / totalDurationSeconds) * 100;
    if (calculatedProgress > 100) calculatedProgress = 100;

    repository.saveCourseProgress(
      courseId,
      positionSeconds,
      calculatedProgress,
    );

    _cachedList = _cachedList.map((course) {
      if (course.id == courseId) {
        return course.copyWith(
          lastPosition: positionSeconds,
          progress: calculatedProgress,
        );
      }
      return course;
    }).toList();

    emit(CoursesLoaded(List.from(_cachedList)));
  }
}
