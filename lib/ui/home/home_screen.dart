import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ishora_tech/ad_helper.dart';
import 'package:ishora_tech/data/models/word_model.dart';
import 'package:ishora_tech/routes/app_route.dart';
import 'package:ishora_tech/ui/drawer/drawer_screen.dart';
import 'package:ishora_tech/ui/widgets/main_button.dart';
import 'package:ishora_tech/ui/widgets/search_sheet.dart';
import 'package:ishora_tech/ui/widgets/shimmer.dart';
import 'package:ishora_tech/utils/app_colors/app_colors.dart';
import 'package:ishora_tech/utils/extensions/extensions.dart';
import 'package:video_player/video_player.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoPlayerController _controller;
  bool isVideoFinished = false;
  WordModel? selectedWord;
  BannerAd? bannerAd;

  @override
  void initState() {
    super.initState();
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdClicked: (ad) {
          setState(() {
            bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Failed to load banner ad: ${error.message}');
          ad.dispose();
        },
      ),
    ).load();
    loadAndPlayRandomWord(context);
  }

  Future<void> loadAndPlayRandomWord(context) async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    // This condition is for demo purposes only to explain every connection type.
    // Use conditions which work for your requirements.
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
    } else {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              icon: Icon(Icons.wifi_off, color: Colors.red),
              title: Text(
                "Internet ulanmagan",
                overflow: TextOverflow.ellipsis,
              ),
              content: Text(
                "Iltimos, internetni yoqing. Aks holda ba'zi funksiyalar ishlamaydi.",
                style: TextStyle(fontSize: 15),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    loadAndPlayRandomWord(context);
                  },
                  child: Text(
                    "Qayta tekshirish",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
      );
    }
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
    setState(() {});
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
          return loadAndPlayRandomWord(context);
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              children: [
                bannerAd == null
                    ? SizedBox()
                    : SizedBox(
                      height: bannerAd!.size.height.toDouble(),
                      width: bannerAd!.size.width.toDouble(),
                      child: AdWidget(ad: bannerAd!),
                    ),
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
                      title: 'Ovozni matnga o\'girish',
                      icon: Icons.translate,
                      onTap: () {
                        Navigator.pushNamed(context, Routes.stt);
                      },
                      color: AppColors.backgroundColor,
                    ),
                    10.pw,
                    MainButton(
                      title: 'To\'plamlar',
                      icon: Icons.folder_copy_outlined,
                      onTap: () {
                        Navigator.pushNamed(context, Routes.category);
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedWord!.word.capitalize(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18.sp,
                                  ),
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
      ),
    );
  }
}
