import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback onTap;

  const HomeSearchBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(Insets.s16, 0, Insets.s16, Insets.s16),
        child: Container(
          width: double.infinity,
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: Insets.s16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F9),
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: const Color(0xFFEFF0F1)),
          ),
          child: Row(
            children: [
              Icon(Icons.search_rounded, size: 20.sp, color: const Color(0xFF838485)),
              SizedBox(width: Insets.s8),
              Expanded(
                child: Text(
                  'ابحث عن خدمة، طلب، أو مساعدة...',
                  style: getRegularStyle(color: const Color(0xFF838485), fontSize: FontSize.s14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
