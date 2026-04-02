import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class ProfileUserCard extends StatelessWidget {
  final String name;
  final String phone;
  final String initials;
  final VoidCallback? onEdit;

  const ProfileUserCard({
    super.key,
    required this.name,
    required this.phone,
    required this.initials,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.s24),
      ),
      child: Row(
        children: [
          // Avatar (RIGHT in RTL)
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E6),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: getRegularStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
            ),
          ),
          SizedBox(width: 4.w),
          // Name & phone
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: getRegularStyle(color: AppColors.white, fontSize: FontSize.s18),
              ),
              Text(
                phone,
                style: getRegularStyle(color: AppColors.white, fontSize: FontSize.s14),
              ),
            ],
          ),
          const Spacer(),
          // Edit button (LEFT in RTL)
          GestureDetector(
            onTap: onEdit,
            child: Container(
              height: 32.h,
              padding: EdgeInsets.symmetric(horizontal: Insets.s16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.s24),
              ),
              alignment: Alignment.center,
              child: Text(
                'تعديل',
                style: getBoldStyle(color: AppColors.primary, fontSize: FontSize.s14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
