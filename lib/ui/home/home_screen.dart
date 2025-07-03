import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ishora_tech/data/models/word_model.dart';
import 'package:ishora_tech/routes/app_route.dart';
import 'package:ishora_tech/ui/drawer/drawer_screen.dart';
import 'package:ishora_tech/ui/widgets/main_button.dart';
import 'package:ishora_tech/ui/widgets/my_snack_bar.dart';
import 'package:ishora_tech/ui/widgets/search_sheet.dart';
import 'package:ishora_tech/ui/widgets/shimmer.dart';
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
        data.map((json) {
          return WordModel.fromJson(json);
        }).toList();

    words.shuffle();
    selectedWord = words.first;

    _controller = VideoPlayerController.networkUrl(
        Uri.parse(selectedWord!.videoUrl),
      )
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          _controller.setVolume(0);
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
      drawer: DrawerScreen(),
      drawerScrimColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.backgroundColor,
        title: const Text("Asosiy"),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.backgroundColor,
        onRefresh: () async {
          return loadAndPlayRandomWord();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              10.ph,
              InkWell(
                borderRadius: BorderRadius.circular(10.r),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    backgroundColor: AppColors.backgroundColor,
                    builder: (_) => SearchSheet(),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2)],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search),
                      Text(
                        ' Qidiruv',
                        style: TextStyle(color: Colors.grey, fontSize: 18.sp),
                      ),
                    ],
                  ),
                ),
              ),
              10.ph,
              Row(
                children: [
                  MainButton(
                    title: 'Tarjimon',
                    icon: Icons.translate,
                    onTap: () {
                      mySnackBar(context, 'Sahifa hali mavjud emas');
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
              15.ph,
              selectedWord == null
                  ? Padding(
                    padding: EdgeInsets.all(8.w),
                    child: const VideoShimmer(),
                  )
                  : Container(
                    padding: EdgeInsets.all(12.w),
                    margin: EdgeInsets.all(5.w),
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
                        10.ph,
                        Container(
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
                        10.ph,
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12.w),
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
                              const Divider(),
                              Text(
                                'Ta\'rif: ${selectedWord!.definition}',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              15.ph,
            ],
          ),
        ),
      ),
    );
  }
}
