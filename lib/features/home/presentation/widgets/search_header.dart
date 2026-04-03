import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class SearchHeader extends StatelessWidget {
  final TextEditingController controller;
  const SearchHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
                ),
                SizedBox(width: Insets.s12),
                Expanded(
                  child: Container(
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
                          child: TextField(
                            controller: controller,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'ابحث عن خدمة، طلب، أو مساعدة...',
                              hintStyle: getRegularStyle(color: const Color(0xFF838485), fontSize: FontSize.s14),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: getRegularStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
                          ),
                        ),
                        if (controller.text.isNotEmpty)
                          GestureDetector(
                            onTap: () => controller.clear(),
                            child: Icon(Icons.close_rounded, size: 18.sp, color: const Color(0xFF838485)),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
        ],
      ),
    );
  }
}
