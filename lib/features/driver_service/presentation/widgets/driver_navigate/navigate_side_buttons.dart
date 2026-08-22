import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class NavigateSideButtons extends StatelessWidget {
  final VoidCallback onFit;
  final VoidCallback onMyLocation;

  const NavigateSideButtons({super.key, required this.onFit, required this.onMyLocation});

  Widget _button(BuildContext context, {required IconData icon, required VoidCallback onTap}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            color: context.colors.surface,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: context.colors.shadow, blurRadius: 8.r, offset: const Offset(0, 2)),
            ],
          ),
          child: Icon(icon, size: 22.sp, color: context.colors.primary),
        ),
      );

  @override
  Widget build(BuildContext context) => Column(
        children: [
          _button(context, icon: Icons.zoom_out_map_rounded, onTap: onFit),
          SizedBox(height: Insets.s8),
          _button(context, icon: Icons.my_location_rounded, onTap: onMyLocation),
        ],
      );
}
