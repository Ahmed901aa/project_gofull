import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

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
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(AppRadius.s24),
      ),
      child: Row(
        children: [
          // Avatar (RIGHT in RTL)
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: context.colors.goldLight,
              shape: BoxShape.circle,
              border: Border.all(color: context.colors.surface),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: getRegularStyle(color: context.colors.textPrimary, fontSize: FontSize.s16),
            ),
          ),
          SizedBox(width: 4.w),
          // Name & phone
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: getRegularStyle(color: context.colors.surface, fontSize: FontSize.s18),
              ),
              Text(
                phone,
                style: getRegularStyle(color: context.colors.surface, fontSize: FontSize.s14),
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
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(AppRadius.s24),
              ),
              alignment: Alignment.center,
              child: Text(
                S.of(context).editBtn,
                style: getBoldStyle(color: context.colors.primary, fontSize: FontSize.s14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
