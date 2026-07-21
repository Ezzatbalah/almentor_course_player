// ignore_for_file: depend_on_referenced_packages

import 'package:almentor_course_player/features/courses/data/repo/course_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/courses/data/repo/course_repository_impl.dart';
import '../../features/courses/presentation/manager/cubit/courses_cubit.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // 1. External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // 2. Repositories (ربط الـ Interface بالـ Implementation)
  sl.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(sl<SharedPreferences>()),
  );

  // 3. Cubits
  sl.registerFactory<CoursesCubit>(() => CoursesCubit(sl<CourseRepository>()));
}
