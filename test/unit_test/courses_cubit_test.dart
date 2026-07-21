import 'package:almentor_course_player/features/courses/data/models/course_model.dart';
import 'package:almentor_course_player/features/courses/data/repo/course_repo.dart';

import 'package:almentor_course_player/features/courses/presentation/manager/cubit/courses_cubit.dart';
import 'package:almentor_course_player/features/courses/presentation/manager/cubit/courses_state.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeCourseRepository implements CourseRepository {
  List<CourseModel> mockCourses = [
    CourseModel(
      id: "c001",
      title: "Test Course",
      thumbnailUrl: "",
      durationSeconds: 30,
      description: "Test Description",
      videoUrl: "",
      progress: 0.0,
      lastPosition: 0,
    ),
  ];

  @override
  Future<List<CourseModel>> loadCourses() async {
    return mockCourses;
  }

  @override
  Future<void> saveCourseProgress(
    String id,
    int position,
    double progress,
  ) async {
    final index = mockCourses.indexWhere((element) => element.id == id);
    if (index != -1) {
      mockCourses[index] = mockCourses[index].copyWith(
        lastPosition: position,
        progress: progress,
      );
    }
  }
}

void main() {
  late CoursesCubit cubit;
  late FakeCourseRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeCourseRepository();
    cubit = CoursesCubit(fakeRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('CoursesCubit Unit Tests', () {
    test('Initial state should be CoursesInitial', () {
      expect(cubit.state, isA<CoursesInitial>());
    });

    test(
      'fetchCourses should emit CoursesLoading then CoursesLoaded',
      () async {
        final expectedStates = [isA<CoursesLoading>(), isA<CoursesLoaded>()];

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        await cubit.fetchCourses();
      },
    );

    test(
      'updatePlaybackProgress correctly updates course progress and position',
      () async {
        await cubit.fetchCourses();

        cubit.updatePlaybackProgress(
          courseId: 'c001',
          positionSeconds: 15,
          totalDurationSeconds: 30,
        );

        final state = cubit.state;
        expect(state, isA<CoursesLoaded>());

        if (state is CoursesLoaded) {
          final course = state.courses.firstWhere((c) => c.id == 'c001');
          expect(course.lastPosition, 15);
          expect(course.progress, 50.0);
        }
      },
    );
  });
}
