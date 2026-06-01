import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class GifCircle extends StatelessWidget {
  final String imagePath;
  const GifCircle({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104.w,
      height: 104.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF336F62), context.colors.primaryLight],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Image.asset(imagePath, fit: BoxFit.contain),
      ),
    );
  }
}
