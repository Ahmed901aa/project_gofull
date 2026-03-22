import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String address;

  const HomeHeader({
    super.key,
    required this.userName,
    this.address = 'شارع التحلية، الرياض',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [Color(0xFF004B3B), Color(0xFF1E6254)],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppRadius.s24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status bar spacer
          SizedBox(height: MediaQuery.of(context).padding.top),

          // Greeting row
          Padding(
            padding: EdgeInsets.fromLTRB(
              Insets.s16,
              Insets.s8,
              Insets.s16,
              0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Greeting — first child → physical RIGHT in RTL
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${AppStrings.welcomePrefix} $userName',
                      style: getBoldStyle(
                        color: AppColors.white,
                        fontSize: FontSize.s20,
                      ),
                    ),
                    Text(
                      'نتمنى لك سلامة الطريق.',
                      style: getRegularStyle(
                        color: AppColors.white,
                        fontSize: FontSize.s12,
                      ),
                    ),
                  ],
                ),

                // Notification bell — last child → physical LEFT in RTL
                IconButton(
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: 24.w,
                    minHeight: 24.w,
                  ),
                  icon: Icon(
                    Icons.notifications_none_outlined,
                    color: AppColors.white,
                    size: 24.sp,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: Insets.s12),

          // Location bar
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.locationSearch,
                arguments: LocationSearchArgs(
                  title: AppStrings.currentLocation,
                  showCurrentLocation: true,
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                Insets.s16,
                0,
                Insets.s16,
                Insets.s16,
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  Insets.s16,
                  4.h,
                  Insets.s8,
                  Insets.s8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.neutral200,
                  borderRadius: BorderRadius.circular(AppRadius.s16),
                  border: Border.all(color: AppColors.neutral500),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Location icon — RIGHT side (RTL start = physical right)
                    Icon(
                      Icons.location_on_outlined,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),

                    SizedBox(width: 8.w),

                    // Text — beside icon, both grouped on RIGHT
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.yourCurrentLocation,
                          style: getRegularStyle(
                            color: AppColors.neutral800,
                            fontSize: FontSize.s12,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          address,
                          style: getMediumStyle(
                            color: AppColors.black,
                            fontSize: FontSize.s14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
