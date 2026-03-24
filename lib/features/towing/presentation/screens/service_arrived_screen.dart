import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/utils/route_args.dart';

class ServiceArrivedScreen extends StatelessWidget {
  final ServiceArrivedArgs? args;

  const ServiceArrivedScreen({super.key, this.args});

  ServiceArrivedArgs get _args => args ?? const ServiceArrivedArgs();

  String get title => _args.title;
  String get subtitle => _args.subtitle;
  String get imagePath => _args.imagePath;
  String get vehicleLabel => _args.vehicleLabel;
  String get vehicleValue => _args.vehicleValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          _Header(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(Insets.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: Insets.s16),
                  _GifCircle(imagePath: imagePath),
                  SizedBox(height: Insets.s16),
                  Text(
                    title,
                    style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: getRegularStyle(color: AppColors.neutral800, fontSize: FontSize.s14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Insets.s16),
                  _SafetySection(),
                  SizedBox(height: Insets.s16),
                  _DriverSection(vehicleLabel: vehicleLabel, vehicleValue: vehicleValue),
                  SizedBox(height: Insets.s16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
                ),
                Text(
                  'وصل مزود الخدمة',
                  style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20),
                ),
                Icon(Icons.info_outline_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
        ],
      ),
    );
  }
}

// ─── GIF Circle ───────────────────────────────────────────────────────────────

class _GifCircle extends StatelessWidget {
  final String imagePath;
  const _GifCircle({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104.w,
      height: 104.w,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF004B3B), Color(0xFF8AACA5)],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Image.asset(imagePath, fit: BoxFit.contain),
      ),
    );
  }
}

// ─── Safety Section ───────────────────────────────────────────────────────────

class _SafetySection extends StatelessWidget {
  static const _items = [
    'تأمين السيارة: يرجى ركن السيارة في مكان آمن ومنبسط.',
    'إطفاء المحرك: تأكد من إطفاء المحرك تماماً قبل بدء التعبئة.',
    'تأكيد النوع: جاري تحضير (بنزين 95) حسب طلبك.',
    'إجراءات السلامة: يرجى الامتناع عن التدخين تماماً في منطقة التعبئة.',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'إرشادات الأمان',
          style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: Insets.s8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
          decoration: BoxDecoration(
            color: AppColors.primary50,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: AppColors.primary),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _items
                .map((text) => _BulletItem(text: text, last: text == _items.last))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  final bool last;
  const _BulletItem({required this.text, this.last = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.h, left: 6.w),
            child: Container(
              width: 5.w,
              height: 5.w,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: getRegularStyle(color: AppColors.primary, fontSize: FontSize.s14),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Driver Section ───────────────────────────────────────────────────────────

class _DriverSection extends StatelessWidget {
  final String vehicleLabel;
  final String vehicleValue;
  const _DriverSection({required this.vehicleLabel, required this.vehicleValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'تفاصيل السائق',
          style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: Insets.s8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.neutral400,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: AppColors.neutral500),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row: action buttons (left) | name + rating + avatar (right)
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(Insets.s16, Insets.s12, Insets.s16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Right (RTL first): avatar + name + rating
                    Row(
                      children: [
                        _Avatar(),
                        SizedBox(width: Insets.s12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'احمد احميد',
                              style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
                            ),
                            SizedBox(height: 4.h),
                            _RatingBadge(),
                          ],
                        ),
                      ],
                    ),
                    // Left (RTL last): action buttons
                    Row(
                      children: [
                        _ActionIcon(icon: Icons.call_rounded),
                        SizedBox(width: Insets.s12),
                        _ActionIcon(icon: Icons.chat_bubble_outline_rounded),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              // Info pills
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(Insets.s16, 0, Insets.s16, Insets.s12),
                child: Row(
                  children: [
                    _InfoPill(label: vehicleLabel, value: vehicleValue),
                    SizedBox(width: Insets.s16),
                    _InfoPill(label: 'رقم اللوحة', value: 'أ ب م - 3541'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  const _ActionIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Icon(icon, size: 16.sp, color: AppColors.primary),
    );
  }
}

class _Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.w,
      height: 56.w,
      decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
      child: Icon(Icons.person_rounded, color: AppColors.neutral800, size: 32.sp),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s8, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, color: const Color(0xFFFFB800), size: 16.sp),
          SizedBox(width: 4.w),
          Text('4.9', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14)),
          SizedBox(width: 2.w),
          Text('(541)', style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s14)),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final String label;
  final String value;
  const _InfoPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: Insets.s16),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBg,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: AppColors.neutral500),
        ),
        child: Column(
          children: [
            Text(label, style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s12)),
            SizedBox(height: 2.h),
            Text(value, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14)),
          ],
        ),
      ),
    );
  }
}
