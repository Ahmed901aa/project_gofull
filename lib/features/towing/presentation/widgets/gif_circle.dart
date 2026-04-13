import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GifCircle extends StatelessWidget {
  final String imagePath;
  const GifCircle({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104.w,
      height: 104.w,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF336F62), Color(0xFF8AACA5)],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Image.asset(imagePath, fit: BoxFit.contain),
      ),
    );
  }
}
