import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
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

const _safetyItems = [
  'إغلاق النوافذ: تأكد من إغلاق جميع نوافذ السيارة وفتحاتها.',
  'أمتعتك الشخصية: تأكد من أخذ جميع ممتلكاتك الشخصية من داخل السيارة.',
];

class TowingStartedScreen extends StatelessWidget {
  final TowingStartedArgs? args;
  const TowingStartedScreen({super.key, this.args});

  TowingStartedArgs get _args => args ?? const TowingStartedArgs();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(children: [
        _buildHeader(context),
        // TODO: Remove — mock only; production: backend triggers when car is loaded
        _MockTriggerButton(
          label: 'محاكاة: الرحلة قيد التنفيذ',
          onTap: () => Navigator.pushReplacementNamed(context, Routes.tripInProgress),
        ),
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
              const SafetySection(items: _safetyItems),
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
          SizedBox(width: 24.sp),
          Text('بدء عملية السحب', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20)),
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

class _MockTriggerButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _MockTriggerButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFD97706),
          side: const BorderSide(color: Color(0xFFD97706)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(label, style: TextStyle(fontSize: 13.sp)),
      ),
    );
  }
}
