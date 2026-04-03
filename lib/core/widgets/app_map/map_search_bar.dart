import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/color_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';

class MapSearchBar extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const MapSearchBar({
    super.key,
    required this.text,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: Insets.s16, vertical: Insets.s12),
        height: 48.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.s12),
          boxShadow: const [
            BoxShadow(
                color: AppColors.shadow,
                blurRadius: 10,
                offset: Offset(0, 2))
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: Insets.s12),
        child: Row(
          children: [
            Icon(Icons.search_rounded,
                color: AppColors.primary, size: 22.sp),
            SizedBox(width: Insets.s8),
            Expanded(
              child: Text(
                text.isEmpty ? 'ابحث عن موقع...' : text,
                style: text.isEmpty
                    ? getRegularStyle(
                        color: AppColors.grey,
                        fontSize: FontSize.s14)
                    : getMediumStyle(
                        color: AppColors.black,
                        fontSize: FontSize.s14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (text.isNotEmpty)
              GestureDetector(
                onTap: onClear,
                behavior: HitTestBehavior.opaque,
                child:
                    Icon(Icons.close, color: AppColors.grey, size: 18.sp),
              ),
          ],
        ),
      ),
    );
  }
}
