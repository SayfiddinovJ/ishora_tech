import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void mySnackBar(context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding: EdgeInsets.all(10.w),
      content: Text(message),
      duration: Duration(seconds: 2),
    ),
  );
}
