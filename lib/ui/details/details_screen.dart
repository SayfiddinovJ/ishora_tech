import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ishora_tech/data/models/word_model.dart';
import 'package:ishora_tech/utils/app_colors/app_colors.dart';
import 'package:ishora_tech/utils/extensions/extensions.dart';
import 'package:video_player/video_player.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key, required this.word});

  final WordModel word;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late VideoPlayerController _controller;
  bool isVideoFinished = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.word.videoUrl),
      )
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      });
    _controller.addListener(() {
      final bool isFinished =
          _controller.value.position >= _controller.value.duration;
      if (isFinished != isVideoFinished) {
        setState(() {
          isVideoFinished = isFinished;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (isVideoFinished) {
      _controller.seekTo(Duration.zero);
      _controller.play();
    } else {
      setState(() {
        _controller.value.isPlaying ? _controller.pause() : _controller.play();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text('Details'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            margin: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              children: [
                Center(
                  child:
                      _controller.value.isInitialized
                          ? AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          )
                          : const CircularProgressIndicator(),
                ),
                10.ph,
                Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: IconButton(
                    onPressed: _togglePlayPause,
                    icon: Icon(
                      isVideoFinished
                          ? Icons.replay
                          : _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.w),
                  margin: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.word.word,
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'To\'plam: ${widget.word.category}',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
