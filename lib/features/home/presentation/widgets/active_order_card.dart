import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class ActiveOrderCard extends StatelessWidget {
  const ActiveOrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock active order data
    return Container(
      padding: EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.inputBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.currentOrder,
                style: getBoldStyle(
                  color: AppColors.black,
                  fontSize: FontSize.s16,
                ),
              ),
              Row(
                children: [
                  // Service type badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Insets.s8,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_gas_station_rounded,
                          size: 14.sp,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          AppStrings.fuelSupply,
                          style: getMediumStyle(
                            color: AppColors.primary,
                            fontSize: FontSize.s12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: Insets.s8),
                  // Status badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Insets.s8,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      AppStrings.inProgress,
                      style: getMediumStyle(
                        color: AppColors.success,
                        fontSize: FontSize.s12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: Sizes.s16),

          // Route info
          _buildRouteRow(
            icon: Icons.radio_button_checked_rounded,
            color: AppColors.primary,
            text: 'المنصورة، مدينة مبارك، شارع مكة',
          ),
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: Column(
              children: List.generate(
                3,
                (_) => Container(
                  width: 2,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  color: AppColors.grey.withValues(alpha: 0.4),
                ),
              ),
            ),
          ),
          _buildRouteRow(
            icon: Icons.location_on_rounded,
            color: AppColors.error,
            text: 'المنصورة، مدينة مبارك، شارع مكة',
          ),
          SizedBox(height: Sizes.s16),

          // Divider
          const Divider(color: AppColors.divider),
          SizedBox(height: Sizes.s8),

          // Price + payment
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    AppStrings.total,
                    style: getRegularStyle(
                      color: AppColors.grey,
                      fontSize: FontSize.s14,
                    ),
                  ),
                  SizedBox(width: Insets.s8),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Insets.s8,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      AppStrings.cash,
                      style: getMediumStyle(
                        color: AppColors.darkGrey,
                        fontSize: FontSize.s12,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                '985.00 ج.م',
                style: getBoldStyle(
                  color: AppColors.black,
                  fontSize: FontSize.s18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRouteRow({
    required IconData icon,
    required Color color,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: color),
        SizedBox(width: Insets.s8),
        Expanded(
          child: Text(
            text,
            style: getRegularStyle(
              color: AppColors.darkGrey,
              fontSize: FontSize.s14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
