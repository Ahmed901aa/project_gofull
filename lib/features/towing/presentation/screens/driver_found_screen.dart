import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/utils/route_args.dart';

// replace with API data later
const _mockDriver = {
  'name': 'محمود عبدالعليم',
  'rating': '4.9',
  'reviewCount': '541',
  'plateNumber': 'أ ب م - 3541',
  'etaSeconds': 15, // mock: 15 seconds for demo — replace with real ETA from API
};

class DriverFoundScreen extends StatefulWidget {
  final DriverFoundArgs? args;
  const DriverFoundScreen({super.key, this.args});

  @override
  State<DriverFoundScreen> createState() => _DriverFoundScreenState();
}

class _DriverFoundScreenState extends State<DriverFoundScreen> {
  static const int _totalSeconds = 15; // mock ETA — replace with API value
  late int _secondsLeft;
  Timer? _timer;

  DriverFoundArgs get _args => widget.args ?? const DriverFoundArgs(
    title: 'تم العثور على ونش!',
    vehicleLabel: 'نوع الونش',
    vehicleValue: 'ونش هيدروليك',
  );

  @override
  void initState() {
    super.initState();
    _secondsLeft = _totalSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) {
        t.cancel();
        if (_args.nextRoute != null) {
          Navigator.pushReplacementNamed(context, _args.nextRoute!);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _etaFormatted {
    final mm = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final ss = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  double get _elapsedProgress => (_totalSeconds - _secondsLeft) / _totalSeconds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Container(
              color: AppColors.scaffoldBg,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildCircle(),
                      SizedBox(height: Insets.s16),
                      Text(
                        _args.title,
                        style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'وافق السائق على طلبك وهو الآن في طريقه إليك.',
                        style: getRegularStyle(color: AppColors.neutral800, fontSize: FontSize.s14),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: Insets.s16),
                      _buildDriverCard(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _buildBottomPanel(context),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) => Container(
    color: AppColors.white,
    child: Column(children: [
      SizedBox(height: MediaQuery.of(context).padding.top),
      Padding(
        padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          // right side (RTL first): close or spacer
          if (_args.showClose)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.close_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
            )
          else
            const SizedBox(width: 24),
          Text('في الطريق لك', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20)),
          // left side (RTL last): info icon
          Icon(Icons.info_outline_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
        ]),
      ),
      const Divider(height: 1, color: Color(0xFFF5F5F5)),
    ]),
  );

  // ─── GIF Circle ───────────────────────────────────────────────────────────

  Widget _buildCircle() => Container(
    width: 104.w, height: 104.w,
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
      child: Image.asset(_args.imagePath ?? 'assets/images/tank_truck.gif', fit: BoxFit.contain),
    ),
  );

  // ─── Driver Card ──────────────────────────────────────────────────────────

  Widget _buildDriverCard() => Container(
    decoration: BoxDecoration(
      color: AppColors.neutral400,
      borderRadius: BorderRadius.circular(AppRadius.s16),
      border: Border.all(color: AppColors.neutral500),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(Insets.s16, Insets.s12, Insets.s16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _mockDriver['name'] as String,
                    style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
                  ),
                  SizedBox(height: 4.h),
                  _RatingBadge(),
                ],
              ),
              SizedBox(width: Insets.s12),
              Container(
                width: 56.w, height: 56.w,
                decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                child: Icon(Icons.person_rounded, color: AppColors.neutral800, size: 32.sp),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(Insets.s16, 0, Insets.s16, Insets.s12),
          child: Row(
            children: [
              _InfoPill(label: _args.vehicleLabel, value: _args.vehicleValue),
              SizedBox(width: Insets.s16),
              _InfoPill(label: 'رقم اللوحة', value: _mockDriver['plateNumber'] as String),
            ],
          ),
        ),
      ],
    ),
  );

  // ─── Bottom Panel ─────────────────────────────────────────────────────────

  Widget _buildBottomPanel(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
      boxShadow: [BoxShadow(color: const Color(0xFFCCCCCC).withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, -2))],
    ),
    padding: EdgeInsets.all(Insets.s16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          textDirection: TextDirection.rtl,
          text: TextSpan(children: [
            TextSpan(
              text: 'الوقت المتوقع للوصول: ',
              style: getRegularStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
            ),
            TextSpan(
              text: '$_etaFormatted دقيقة',
              style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
            ),
          ]),
        ),
        SizedBox(height: Insets.s8),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.s16),
          child: LinearProgressIndicator(
            value: _elapsedProgress,
            backgroundColor: AppColors.neutral600,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 6.h,
          ),
        ),
        SizedBox(height: Insets.s16),
        Row(
          children: [
            Expanded(child: _ActionButton(label: 'اتصال بالسائق', icon: Icons.call_rounded)),
            SizedBox(width: Insets.s12),
            Expanded(child: _ActionButton(label: 'إرسال رسالة', icon: Icons.chat_bubble_outline_rounded)),
          ],
        ),
      ],
    ),
  );
}

// ─── Shared Private Widgets ───────────────────────────────────────────────────

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
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.star_rounded, color: const Color(0xFFFFB800), size: 16.sp),
        SizedBox(width: 4.w),
        Text('4.9', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14)),
        SizedBox(width: 2.w),
        Text('(541)', style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s14)),
      ]),
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
        child: Column(children: [
          Text(label, style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s12)),
          SizedBox(height: 2.h),
          Text(value, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14)),
        ]),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  const _ActionButton({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: OutlinedButton.icon(
        onPressed: () {}, // placeholder — wire up with real call/chat later
        icon: Icon(icon, size: 20.sp, color: AppColors.primary),
        label: Text(label, style: getBoldStyle(color: AppColors.primary, fontSize: FontSize.s16)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)),
        ),
      ),
    );
  }
}
