import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class ServiceHeader extends StatelessWidget {
  final String title;
  const ServiceHeader({super.key, required this.title});

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_rounded, size: 22.sp, color: const Color(0xFF0E0E0E)),
                ),
                Text(title, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20)),
                const SizedBox(width: 24),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
        ],
      ),
    );
  }
}
