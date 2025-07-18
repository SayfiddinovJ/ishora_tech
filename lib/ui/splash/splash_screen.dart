import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ishora_tech/routes/app_route.dart';
import 'package:ishora_tech/utils/app_colors/app_colors.dart';
import 'package:ishora_tech/utils/app_images/app_images.dart';
import 'package:ishora_tech/utils/extensions/extensions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // _init() async {
  //   _navigateToApp(context);
  // }
  //
  // @override
  // void initState() {
  //   _init();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    _navigateToApp(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.logo),
            20.ph,
            Image.asset(AppImages.techText),
          ],
        ),
      ),
    );
  }

  _navigateToApp(context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, Routes.app);
    });
  }
}
