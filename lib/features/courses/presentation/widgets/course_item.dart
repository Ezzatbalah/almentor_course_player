import 'package:almentor_course_player/features/courses/presentation/screens/course_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/course_model.dart';

class CourseItem extends StatelessWidget {
  final CourseModel course;

  const CourseItem({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      child: ListTile(
        contentPadding: EdgeInsets.all(8.w),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: Image.network(
            course.thumbnailUrl,
            width: 80.w,
            height: 60.h,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 80.w,
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image, color: Colors.grey),
            ),
          ),
        ),
        title: Text(
          course.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6.h),
            LinearProgressIndicator(
              value: course.progress / 100,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 4.h),
            Text(
              "${course.progress.toStringAsFixed(0)}% watched",
              style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CourseDetailScreen(course: course),
            ),
          );
        },
      ),
    );
  }
}
