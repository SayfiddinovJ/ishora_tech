import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ishora_tech/bloc/word/word_bloc.dart';
import 'package:ishora_tech/routes/app_route.dart';
import 'package:ishora_tech/utils/app_colors/app_colors.dart';
import 'package:ishora_tech/utils/app_images/app_images.dart';
import 'package:ishora_tech/utils/extensions/extensions.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text('To\'plamlar'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.w,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 10.h,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  context.read<WordBloc>().add(
                    GetEvent(categoryName: names[index].toLowerCase().replaceAll('\'', '')),
                  );
                  Navigator.pushNamed(context, Routes.words);
                },
                child: Card(
                  color: Color(0xFFFEF7FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1.r),
                  ),
                  elevation: 5,
                  child: Column(
                    children: [
                      5.ph,
                      Flexible(
                        child: Image.asset(
                          images[index],
                          width: 100.w,
                          height: 100.h,
                        ),
                      ),
                      Text(
                        names[index],
                        style: TextStyle(
                          color: Color(0xFF434D65),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
