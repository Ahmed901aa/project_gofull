import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = currentIndex == index;
    final color = isActive
        ? context.colors.primary
        : context.isDarkMode
            ? context.colors.iconSecondary
            : context.colors.primaryLight;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24.sp, color: color),
            SizedBox(height: 8.h),
            Text(
              label,
              style: isActive
                  ? getBoldStyle(color: color, fontSize: FontSize.s14)
                  : getRegularStyle(color: color, fontSize: FontSize.s14),
            ),
          ],
        ),
      ),
    );
  }
}
