import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/color_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';

class MapConfirmButton extends StatelessWidget {
  final String address;
  final String label;
  final VoidCallback onTap;

  const MapConfirmButton({
    super.key,
    required this.address,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          Insets.s16, Insets.s16, Insets.s16, 32.h),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 16,
              offset: Offset(0, -4))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (address.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.location_on,
                    color: AppColors.primary, size: 16.sp),
                SizedBox(width: Insets.s8),
                Expanded(
                  child: Text(
                    address,
                    style: getMediumStyle(
                        color: AppColors.black,
                        fontSize: FontSize.s12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: Insets.s12),
          ],
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppRadius.s12)),
              ),
              child: Text(label,
                  style: getBoldStyle(
                      color: AppColors.white,
                      fontSize: FontSize.s16)),
            ),
          ),
        ],
      ),
    );
  }
}
