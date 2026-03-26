import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import '../widgets/arrived_bottom_action.dart';
import '../widgets/arrived_car_photos.dart';
import '../widgets/arrived_payment_card.dart';
import '../widgets/arrived_safety_card.dart';
import '../widgets/gif_circle.dart';

class DriverArrivedScreen extends StatelessWidget {
  final TripInProgressArgs? args;
  const DriverArrivedScreen({super.key, this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(Insets.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: Insets.s16),
                  Center(child: GifCircle(imagePath: 'assets/images/shield.gif')),
                  SizedBox(height: Insets.s16),
                  Text(
                    'تمت المهمة بنجاح!',
                    style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'تم إنزال السيارة في وجهة التوصيل المحددة. يرجى التأكد من سلامة السيارة قبل إتمام الدفع.',
                    style: getRegularStyle(color: AppColors.neutral800, fontSize: FontSize.s14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Insets.s24),
                  const ArrivedSafetyCard(),
                  SizedBox(height: Insets.s16),
                  const ArrivedCarPhotos(),
                  SizedBox(height: Insets.s16),
                  const ArrivedPaymentCard(),
                  SizedBox(height: Insets.s16),
                ],
              ),
            ),
          ),
          const ArrivedBottomAction(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
        color: AppColors.white,
        child: Column(children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 24.sp),
                Text('وصل السائق للوجهة', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20)),
                Icon(Icons.info_outline_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
        ]),
      );
}
