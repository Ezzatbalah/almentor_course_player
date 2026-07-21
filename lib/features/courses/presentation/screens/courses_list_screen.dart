import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/course_model.dart';
import '../widgets/course_item.dart';

class CoursesListScreen extends StatelessWidget {
  const CoursesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = CourseModel.mockCourses;

    return Scaffold(
      appBar: AppBar(title: const Text("My Courses"), elevation: 0),
      body: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return CourseItem(course: courses[index]);
        },
      ),
    );
  }
}
