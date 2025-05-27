import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ishora_tech/data/models/word_model.dart';
import 'package:ishora_tech/routes/app_route.dart';
import 'package:ishora_tech/ui/widgets/main_button.dart';
import 'package:ishora_tech/utils/app_colors/app_colors.dart';
import 'package:ishora_tech/utils/extensions/extensions.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoPlayerController _controller;
  bool isVideoFinished = false;
  WordModel? selectedWord;

  @override
  void initState() {
    super.initState();
    loadAndPlayRandomWord();
  }

  Future<void> loadAndPlayRandomWord() async {
    final String response = await rootBundle.loadString(
      'assets/word/word.json',
    );
    final List<dynamic> data = jsonDecode(response);
    final List<WordModel> words =
        data.map((json) => WordModel.fromJson(json)).toList();

    words.shuffle(); // tasodifiy aralashtiramiz
    selectedWord = words.first; // birinchi elementni tanlaymiz

    _controller = VideoPlayerController.networkUrl(
        Uri.parse(selectedWord!.videoUrl),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: const Text("Asosiy"),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            20.ph,
            Row(
              children: [
                MainButton(
                  title: 'Lug\'at',
                  icon: Icons.book_outlined,
                  onTap: () {
                    Navigator.pushNamed(context, RouteNames.dictionary);
                  },
                  color: AppColors.backgroundColor,
                ),
                10.pw,
                MainButton(
                  title: 'To\'plamlar',
                  icon: Icons.folder_copy_outlined,
                  onTap: () {
                    Navigator.pushNamed(context, RouteNames.category);
                  },
                  color: Colors.white,
                ),
              ],
            ),
            10.ph,
            selectedWord == null
                ? const Center(child: CircularProgressIndicator())
                : Container(
                  padding: EdgeInsets.all(12.w),
                  margin: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
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
                              selectedWord!.word,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'To\'plam: ${selectedWord!.word}',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: IconButton(
                          icon: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                          onPressed: () {
                            setState(() {
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
            15.ph,
          ],
        ),
      ),
    );
  }
}
