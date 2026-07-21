// ignore_for_file: depend_on_referenced_packages

import 'package:almentor_course_player/features/courses/data/models/course_model.dart';
import 'package:almentor_course_player/features/courses/presentation/manager/cubit/courses_cubit.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

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
  int _lastSavedSecond = -1;

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

      _videoController!.addListener(_onVideoPositionChanged);

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

  void _onVideoPositionChanged() {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return;
    }

    final currentPosition = _videoController!.value.position.inSeconds;
    final totalDuration = _videoController!.value.duration.inSeconds;

    if (totalDuration > 0 && currentPosition != _lastSavedSecond) {
      _lastSavedSecond = currentPosition;

      context.read<CoursesCubit>().updatePlaybackProgress(
        courseId: widget.course.id,
        positionSeconds: currentPosition,
        totalDurationSeconds: totalDuration,
      );
    }
  }

  @override
  void dispose() {
    _videoController?.removeListener(_onVideoPositionChanged);
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
