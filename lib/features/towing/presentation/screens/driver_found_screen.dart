import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/service_bottom_button.dart';
import 'package:project_gofull/core/widgets/service_header.dart';
import 'package:project_gofull/features/towing/presentation/widgets/driver_card.dart';

class DriverFoundScreen extends StatelessWidget {
  const DriverFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(top: false,
        child: Column(
          children: [
            const ServiceHeader(title: 'تم العثور على سائق'),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Success icon
                      Container(
                        width: 96.w,
                        height: 96.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF004B3B), Color(0xFF8AACA5)],
                          ),
                        ),
                        child: Icon(Icons.check_rounded, color: AppColors.white, size: 48.sp),
                      ),
                      SizedBox(height: Insets.s24),
                      Text(
                        'تم العثور على مزود وقود!',
                        style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: Insets.s8),
                      Text(
                        'وافق السائق على طلبك وهو الآن في طريقه إليك.',
                        style: getRegularStyle(color: AppColors.neutral800, fontSize: FontSize.s14),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: Insets.s24),
                      const DriverCard(),
                    ],
                  ),
                ),
              ),
            ),
            ServiceBottomButton(label: 'تتبع السائق', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
