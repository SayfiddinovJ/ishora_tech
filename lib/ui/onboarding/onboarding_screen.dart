import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ishora_tech/data/onboarding_data/onboarding_data.dart';
import 'package:ishora_tech/data/storage/storage_repo.dart';
import 'package:ishora_tech/routes/app_route.dart';
import 'package:ishora_tech/utils/app_colors/app_colors.dart';
import 'package:ishora_tech/utils/app_images/app_images.dart';
import 'package:ishora_tech/utils/extensions/extensions.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: onboardingData.length,
                onPageChanged:
                    (index) => setState(() {
                      _currentPage = index;
                    }),
                itemBuilder: (context, index) {
                  final data = onboardingData[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(data['image']!),
                        32.ph,
                        index != 1
                            ? Flexible(
                              child: Image.asset(
                                data['title']!,
                                width: double.infinity,
                              ),
                            )
                            : Column(
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Image.asset(
                                        data['title']!,
                                        width: double.infinity - 24,
                                      ),
                                    ),
                                    100.pw,
                                  ],
                                ),
                                Row(
                                  children: [
                                    50.pw,
                                    Visibility(
                                      visible: index == 1,
                                      child: Flexible(
                                        child: Image.asset(
                                          AppImages.secondBoardingText2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                      ],
                    ),
                  );
                },
              ),
            ),
            24.ph,
            Padding(
              padding: EdgeInsets.only(right: 24.w),
              child: Row(
                children: [
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      if (_currentPage == onboardingData.length - 1) {
                        StorageRepository.putBool('isUserEntered', true);
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.home,
                          (route) => false,
                        );
                      } else {
                        _controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          _currentPage == onboardingData.length - 1
                              ? "Boshlash "
                              : "Davom etish ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(Icons.arrow_forward_rounded, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            30.ph,
          ],
        ),
      ),
    );
  }
}
