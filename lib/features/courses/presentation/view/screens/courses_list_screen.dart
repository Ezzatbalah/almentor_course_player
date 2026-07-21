import 'package:almentor_course_player/features/courses/presentation/manager/cubit/courses_cubit.dart';
import 'package:almentor_course_player/features/courses/presentation/manager/cubit/courses_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/course_item.dart';

class CoursesListScreen extends StatelessWidget {
  const CoursesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Courses"), elevation: 0),
      body: BlocBuilder<CoursesCubit, CoursesState>(
        builder: (context, state) {
          if (state is CoursesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CoursesError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(fontSize: 14.sp, color: Colors.red),
              ),
            );
          } else if (state is CoursesLoaded) {
            if (state.courses.isEmpty) {
              return const Center(child: Text("No courses available."));
            }
            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: state.courses.length,
              itemBuilder: (context, index) {
                return CourseItem(course: state.courses[index]);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
