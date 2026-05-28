import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

class PhotoLogSection extends StatefulWidget {
  const PhotoLogSection({super.key});

  @override
  State<PhotoLogSection> createState() => _PhotoLogSectionState();
}

class _PhotoLogSectionState extends State<PhotoLogSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.neutral400,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Insets.s16,
                vertical: Insets.s12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 24.sp,
                      color: const Color(0xFF0E0E0E),
                    ),
                  ),
                  Text(
                    S.of(context).photoLog,
                    style: getBoldStyle(
                      color: const Color(0xFF0E0E0E),
                      fontSize: FontSize.s16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            Divider(color: AppColors.neutral500, height: 1, thickness: 1),
            Padding(
              padding: EdgeInsets.all(Insets.s12),
              child: Row(
                children: List.generate(
                  3,
                  (i) => Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(end: i > 0 ? Insets.s8 : 0),
                      child: const _PhotoPlaceholder(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88.h,
      decoration: BoxDecoration(
        color: AppColors.neutral200,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500),
      ),
      child: Icon(Icons.image_outlined, size: 28.sp, color: AppColors.neutral600),
    );
  }
}
