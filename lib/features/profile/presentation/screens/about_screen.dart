import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_gofull/core/resources/assets_manager.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/app_header.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: Column(
          children: [
            const AppHeader(title: 'عن Go Full'),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(Insets.s16),
                child: Column(
                  children: [
                    SizedBox(height: 24.h),
                    // Logo
                    Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      padding: EdgeInsets.all(20.w),
                      child: SvgPicture.asset(
                        SvgAssets.logo,
                        colorFilter: const ColorFilter.mode(
                            AppColors.white, BlendMode.srcIn),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'GO FULL',
                      style: getBoldStyle(
                          color: AppColors.primary, fontSize: FontSize.s24),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'الإصدار 1.0.0',
                      style: getRegularStyle(
                          color: AppColors.grey, fontSize: FontSize.s14),
                    ),
                    SizedBox(height: 32.h),

                    // Description
                    _buildCard(
                      icon: Icons.local_gas_station_rounded,
                      title: 'إمداد وقود',
                      description:
                          'خدمة توصيل الوقود إلى موقعك مباشرة. بنزين أو ديزل، نوصلك أينما كنت.',
                    ),
                    SizedBox(height: 12.h),
                    _buildCard(
                      icon: Icons.fire_truck_rounded,
                      title: 'خدمة ساحبة',
                      description:
                          'سحب وإنقاذ سريع لسيارتك. فريق متخصص ومجهز لنقل مركبتك بأمان.',
                    ),
                    SizedBox(height: 12.h),
                    _buildCard(
                      icon: Icons.speed_rounded,
                      title: 'سرعة الاستجابة',
                      description:
                          'نربطك بأقرب مزود خدمة في منطقتك لضمان وصول المساعدة في أسرع وقت.',
                    ),
                    SizedBox(height: 12.h),
                    _buildCard(
                      icon: Icons.verified_user_rounded,
                      title: 'أمان وموثوقية',
                      description:
                          'جميع مزودي الخدمة معتمدون ومتحققون. تقييمات شفافة لضمان جودة الخدمة.',
                    ),

                    SizedBox(height: 32.h),
                    Text(
                      '© 2026 GO FULL. جميع الحقوق محفوظة.',
                      style: getRegularStyle(
                          color: AppColors.grey, fontSize: FontSize.s12),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: const Color(0xFFEFF0F1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: getSemiBoldStyle(
                        color: const Color(0xFF0E0E0E),
                        fontSize: FontSize.s16)),
                SizedBox(height: 4.h),
                Text(description,
                    style: getRegularStyle(
                        color: AppColors.darkGrey, fontSize: FontSize.s14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
