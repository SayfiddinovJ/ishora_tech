import 'package:flutter/material.dart';
import 'package:ishora_tech/utils/app_colors/app_colors.dart';
import 'package:ishora_tech/utils/app_images/app_images.dart';
import 'package:ishora_tech/utils/extensions/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            leading: Icon(Icons.telegram),
            onTap: () async {
              final Uri telegramUrl = Uri.parse('https://t.me/IshoraTech');
              if (await canLaunchUrl(telegramUrl)) {
                await launchUrl(telegramUrl);
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Linkni ochib bo‘lmadi')),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Share'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sahifa hali mavjud emas')),
              );
            },
          ),
        ],
      ),
    );
  }
}
