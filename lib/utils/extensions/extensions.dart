import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension Space on num {
  SizedBox get ph => SizedBox(height: toDouble().h);

  SizedBox get pw => SizedBox(width: toDouble().w);
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}