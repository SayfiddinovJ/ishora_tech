import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ishora_tech/utils/app_colors/app_colors.dart';
import 'package:ishora_tech/utils/app_images/app_images.dart';
import 'package:ishora_tech/utils/extensions/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.backgroundColor,
      child: Builder(
        builder: (drawerContext) {
          return SafeArea(
            child: Column(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: AppColors.backgroundColor),
                  child: Column(
                    children: [
                      Flexible(child: Image.asset(AppImages.logo)),
                      20.ph,
                      Flexible(child: Image.asset(AppImages.techText)),
                    ],
                  ),
                ),
                ListTile(
                  title: Text('Telegram channel'),
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  leading: Icon(Icons.telegram, color: Colors.white),
                  onTap: () async {
                    final Uri telegramUrl = Uri.parse(
                      'https://t.me/IshoraTech',
                    );
                    if (await canLaunchUrl(telegramUrl)) {
                      await launchUrl(telegramUrl);
                    } else if (context.mounted) {
                      ScaffoldMessenger.of(drawerContext).showSnackBar(
                        const SnackBar(content: Text('Linkni ochib bo‘lmadi')),
                      );
                    }
                    context.mounted ? Navigator.pop(context) : null;
                  },
                ),
                ListTile(
                  leading: Icon(Icons.share, color: Colors.white),
                  title: Text('Share'),
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(drawerContext).showSnackBar(
                      const SnackBar(content: Text('Sahifa hali mavjud emas')),
                    );
                  },
                ),
                const Spacer(),
                Center(
                  child: Text(
                    'Version 1.0.2',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                10.ph,
              ],
            ),
          );
        },
      ),
    );
  }
}
