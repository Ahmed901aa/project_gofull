import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class DriverStatusToggle extends StatefulWidget {
  final bool initialActive;
  final ValueChanged<bool>? onStatusChanged;

  const DriverStatusToggle({
    super.key,
    this.initialActive = true,
    this.onStatusChanged,
  });

  @override
  State<DriverStatusToggle> createState() => _DriverStatusToggleState();
}

class _DriverStatusToggleState extends State<DriverStatusToggle> {
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _isActive = widget.initialActive;
  }

  void _toggle() {
    setState(() {
      _isActive = !_isActive;
    });
    widget.onStatusChanged?.call(_isActive);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Insets.s12,
          vertical: Insets.s8,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.s24),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isActive ? AppColors.success : AppColors.error,
              ),
            ),
            SizedBox(width: Insets.s8),
            Text(
              _isActive ? AppStrings.active : AppStrings.inactive,
              style: getSemiBoldStyle(
                color: AppColors.darkGrey,
                fontSize: FontSize.s14,
              ),
            ),
            SizedBox(width: Insets.s4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18.w,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
