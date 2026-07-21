import 'package:almentor_course_player/features/courses/data/models/course_model.dart';
import 'package:almentor_course_player/features/courses/data/repo/course_repo.dart';
import 'package:almentor_course_player/features/courses/presentation/manager/cubit/courses_cubit.dart';
import 'package:almentor_course_player/features/courses/presentation/view/screens/courses_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeCourseRepository implements CourseRepository {
  @override
  Future<List<CourseModel>> loadCourses() async {
    return [
      CourseModel(
        id: "c001",
        title: "Intro to UI/UX Design",
        thumbnailUrl: "https://picsum.photos/seed/course1/400/225",
        durationSeconds: 30,
        description: "Test Description",
        videoUrl: "",
        progress: 25.0,
        lastPosition: 7,
      ),
    ];
  }

  @override
  Future<void> saveCourseProgress(
    String id,
    int position,
    double progress,
  ) async {}
}

void main() {
  Widget buildTestableWidget(CoursesCubit cubit) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return MaterialApp(
          home: BlocProvider.value(
            value: cubit,
            child: const CoursesListScreen(),
          ),
        );
      },
    );
  }

  testWidgets('Renders CoursesListScreen and shows loaded course title', (
    WidgetTester tester,
  ) async {
    final fakeRepo = FakeCourseRepository();
    final cubit = CoursesCubit(fakeRepo);

    // 1. بناء الـ Widget
    await tester.pumpWidget(buildTestableWidget(cubit));

    // 2. استدعاء Fetch وتمرير وقت الـ Future.delayed (300ms)
    cubit.fetchCourses();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    // 3. التحقق من ظهور عنوان الكورس
    expect(find.text("Intro to UI/UX Design"), findsOneWidget);
  });
}
