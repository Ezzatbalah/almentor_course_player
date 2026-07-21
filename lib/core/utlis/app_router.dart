import 'package:almentor_course_player/features/courses/presentation/view/screens/course_detail_screen.dart';
import 'package:almentor_course_player/features/courses/presentation/view/screens/courses_list_screen.dart';
import 'package:go_router/go_router.dart';

import '../../features/courses/data/models/course_model.dart';

abstract class AppRoutes {
  static const String coursesList = '/';
  static const String courseDetail = '/courseDetail';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.coursesList,
  routes: [
    GoRoute(
      path: AppRoutes.coursesList,
      builder: (context, state) => const CoursesListScreen(),
    ),
    GoRoute(
      path: AppRoutes.courseDetail,
      builder: (context, state) {
        final course = state.extra as CourseModel;
        return CourseDetailScreen(course: course);
      },
    ),
  ],
);
