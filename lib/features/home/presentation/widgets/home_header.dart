import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'home_location_bar.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onSearchTap;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF004B3B), Color(0xFF8AACA5)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppRadius.s24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s8, Insets.s16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppStrings.welcomePrefix} $userName',
                      style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s20),
                    ),
                    Text(
                      'نتمنى لك سلامة الطريق.',
                      style: getRegularStyle(color: AppColors.white, fontSize: FontSize.s12),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/notifications'),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: 24.w, minHeight: 24.w),
                  icon: Icon(Icons.notifications_none_outlined, color: AppColors.white, size: 24.sp),
                ),
              ],
            ),
          ),
          SizedBox(height: Insets.s12),
          HomeSearchBar(onTap: onSearchTap),
        ],
      ),
    );
  }
}
