import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/features/towing/presentation/widgets/driver_details_card.dart';
import 'package:project_gofull/features/towing/presentation/widgets/gif_circle.dart';
import 'package:project_gofull/features/towing/presentation/widgets/safety_section.dart';

// replace with API data later
const _mockDriver = {
  'name': 'احمد احميد',
  'rating': '4.9',
  'reviewCount': '541',
  'plateNumber': 'أ ب م - 3541',
};

class ServiceArrivedScreen extends StatelessWidget {
  final ServiceArrivedArgs? args;
  const ServiceArrivedScreen({super.key, this.args});

  ServiceArrivedArgs get _args => args ?? const ServiceArrivedArgs();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(children: [
        _buildHeader(context),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(Insets.s16),
            child: Column(children: [
              SizedBox(height: Insets.s16),
              GifCircle(imagePath: _args.imagePath),
              SizedBox(height: Insets.s16),
              Text(_args.title, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18), textAlign: TextAlign.center),
              SizedBox(height: 4.h),
              Text(_args.subtitle, style: getRegularStyle(color: AppColors.neutral800, fontSize: FontSize.s14), textAlign: TextAlign.center),
              SizedBox(height: Insets.s16),
              const SafetySection(),
              SizedBox(height: Insets.s16),
              _buildDriverSection(),
              SizedBox(height: Insets.s16),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
    color: AppColors.white,
    child: Column(children: [
      SizedBox(height: MediaQuery.of(context).padding.top),
      Padding(
        padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.close_rounded, size: 24.sp, color: const Color(0xFF0E0E0E))),
          Text('وصل مزود الخدمة', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20)),
          Icon(Icons.info_outline_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
        ]),
      ),
      const Divider(height: 1, color: Color(0xFFF5F5F5)),
    ]),
  );

  Widget _buildDriverSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text('تفاصيل السائق', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18), textAlign: TextAlign.right),
      SizedBox(height: Insets.s8),
      DriverDetailsCard(
        name: _mockDriver['name']!,
        rating: _mockDriver['rating']!,
        reviewCount: _mockDriver['reviewCount']!,
        plateNumber: _mockDriver['plateNumber']!,
        vehicleLabel: _args.vehicleLabel,
        vehicleValue: _args.vehicleValue,
        showActionIcons: true,
      ),
    ],
  );
}
