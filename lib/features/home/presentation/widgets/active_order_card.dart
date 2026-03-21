import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class ActiveOrderCard extends StatelessWidget {
  const ActiveOrderCard({super.key});

  // Mock data
  static const String _fromAddress = 'المنصورة، مدينة مبارك، شارع مكة';
  static const String _toAddress = 'الرياض، حي النزهة، شارع الأمير';
  static const String _price = '985.00 ج.م';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: Sizes.s12),
            child: Text(
              'طلبك الحالي',
              style: getSemiBoldStyle(
                color: const Color(0xFF0E0E0E),
                fontSize: FontSize.s18,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.neutral50,
              borderRadius: BorderRadius.circular(AppRadius.s16),
              border: Border.all(color: AppColors.neutral500),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Badges row
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Insets.s16,
                    vertical: Insets.s12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Service badge — "خدمة ونش" → physical RIGHT in RTL
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Insets.s12,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary50,
                          borderRadius: BorderRadius.circular(AppRadius.s16),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'خدمة ونش',
                              style: getMediumStyle(
                                color: AppColors.primary,
                                fontSize: FontSize.s12,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.local_shipping_outlined,
                              size: 14.sp,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                      // Status badge — "قيد التنفيذ" → physical LEFT in RTL
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Insets.s12,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.neutral500,
                          borderRadius: BorderRadius.circular(AppRadius.s16),
                          border: Border.all(color: AppColors.neutral600),
                        ),
                        child: Text(
                          'قيد التنفيذ',
                          style: getMediumStyle(
                            color: const Color(0xFF0E0E0E),
                            fontSize: FontSize.s12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Route card
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                  child: Container(
                    padding: EdgeInsets.all(Insets.s12),
                    decoration: BoxDecoration(
                      color: AppColors.scaffoldBg,
                      borderRadius: BorderRadius.circular(AppRadius.s16),
                      border: Border.all(color: AppColors.neutral500),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Origin → physical RIGHT in RTL
                        Expanded(
                          child: _AddressColumn(
                            label: 'نقطة الانطلاق',
                            address: _fromAddress,
                          ),
                        ),
                        _RouteConnector(),
                        // Destination → physical LEFT in RTL
                        Expanded(
                          child: _AddressColumn(
                            label: 'نقطة الوصول',
                            address: _toAddress,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Divider
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Sizes.s12),
                  child: Divider(
                    color: AppColors.neutral500,
                    height: 1,
                    thickness: 1,
                  ),
                ),

                // Price row
                Padding(
                  padding: EdgeInsets.only(
                    left: Insets.s16,
                    right: Insets.s16,
                    bottom: Insets.s12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Labels (الإجمالي + كاش) → physical RIGHT in RTL
                      Row(
                        children: [
                          Text(
                            'الإجمالي',
                            style: getRegularStyle(
                              color: AppColors.neutral900,
                              fontSize: FontSize.s16,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Insets.s12,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary50,
                              borderRadius: BorderRadius.circular(AppRadius.s16),
                            ),
                            child: Text(
                              'كاش',
                              style: getRegularStyle(
                                color: AppColors.primary,
                                fontSize: FontSize.s12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Price → physical LEFT in RTL
                      Text(
                        _price,
                        style: getBoldStyle(
                          color: const Color(0xFF0E0E0E),
                          fontSize: FontSize.s16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressColumn extends StatelessWidget {
  final String label;
  final String address;

  const _AddressColumn({required this.label, required this.address});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: getRegularStyle(
            color: AppColors.neutral800,
            fontSize: FontSize.s12,
          ),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 2.h),
        Text(
          address,
          style: getMediumStyle(
            color: const Color(0xFF0E0E0E),
            fontSize: FontSize.s12,
          ),
          textAlign: TextAlign.right,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _RouteConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          ...List.generate(
            4,
            (_) => Container(
              width: 2.w,
              height: 4.h,
              margin: EdgeInsets.symmetric(vertical: 1.5.h),
              color: AppColors.neutral600,
            ),
          ),
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
