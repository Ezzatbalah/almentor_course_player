import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/course_model.dart';

class CourseDetailScreen extends StatefulWidget {
  final CourseModel course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isError = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  Future<void> _initVideoPlayer() async {
    try {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.course.videoUrl),
      );

      await _videoController!.initialize();

      if (widget.course.lastPosition > 0) {
        await _videoController!.seekTo(
          Duration(seconds: widget.course.lastPosition),
        );
      }

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        looping: false,
        aspectRatio: 16 / 9,
        errorBuilder: (context, errorMessage) {
          return const Center(
            child: Text(
              "Failed to stream video resource",
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      );

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.course.title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(color: Colors.black, child: _buildVideoView()),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              "Course Description",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                widget.course.description,
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.4,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoView() {
    if (_isError) {
      return const Center(
        child: Text(
          "Error loading video controller stream.",
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    if (_isInitialized && _chewieController != null) {
      return Chewie(controller: _chewieController!);
    }
    return const Center(child: CircularProgressIndicator(color: Colors.white));
  }
}
