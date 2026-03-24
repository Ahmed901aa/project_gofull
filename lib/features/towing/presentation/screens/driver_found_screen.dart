import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/features/towing/presentation/widgets/driver_card.dart';

class DriverFoundScreen extends StatefulWidget {
  final DriverFoundArgs? args;
  const DriverFoundScreen({super.key, this.args});
  @override
  State<DriverFoundScreen> createState() => _DriverFoundScreenState();
}

class _DriverFoundScreenState extends State<DriverFoundScreen> {
  int _secondsLeft = 15 * 60;
  Timer? _timer;

  DriverFoundArgs get _args => widget.args ?? const DriverFoundArgs(
    title: 'تم العثور على ونش!',
    vehicleLabel: 'نوع الونش',
    vehicleValue: 'ونش هيدروليك',
  );

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) t.cancel();
    });
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(children: [
        _buildHeader(context),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Insets.s16),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(height: Insets.s24),
              _buildCircle(),
              SizedBox(height: Insets.s16),
              Text(_args.title, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18), textAlign: TextAlign.center),
              SizedBox(height: 4.h),
              Text('وافق السائق على طلبك وهو الآن في طريقه إليك.', style: getRegularStyle(color: AppColors.neutral800, fontSize: FontSize.s14), textAlign: TextAlign.center),
              SizedBox(height: Insets.s16),
              DriverCard(vehicleLabel: _args.vehicleLabel, vehicleValue: _args.vehicleValue),
            ]),
          ),
        ),
        _buildBottomPanel(context),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
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
          if (_args.showClose)
            GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.close_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)))
          else
            const SizedBox(width: 24),
          Text('في الطريق لك', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20)),
          Icon(Icons.info_outline_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
        ]),
      ),
      const Divider(height: 1, color: Color(0xFFF5F5F5)),
    ]),
  );

  Widget _buildCircle() => Container(
    width: 104.w, height: 104.w,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF004B3B), Color(0xFF8AACA5)]),
    ),
    child: Padding(
      padding: EdgeInsets.all(20.w),
      child: Image.asset(_args.imagePath ?? 'assets/images/tank_truck.gif', fit: BoxFit.contain),
    ),
  );

  Widget _buildBottomPanel(BuildContext context) {
    final mm = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final ss = (_secondsLeft % 60).toString().padLeft(2, '0');
    return Container(
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)), boxShadow: [BoxShadow(color: const Color(0xFFCCCCCC).withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, -2))]),
      padding: EdgeInsets.all(Insets.s16),
      child: Column(children: [
        RichText(textDirection: TextDirection.rtl, text: TextSpan(children: [
          TextSpan(text: 'الوقت المتوقع للوصول: ', style: getRegularStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
          TextSpan(text: '$mm:$ss دقيقة', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s16)),
        ])),
        SizedBox(height: Insets.s8),
        Container(height: 6.h, decoration: BoxDecoration(color: const Color(0xFFD9DADB), borderRadius: BorderRadius.circular(AppRadius.s16))),
        SizedBox(height: Insets.s16),
        Row(children: [
          Expanded(child: _actionButton(label: 'اتصال بالسائق', icon: Icons.call_rounded)),
          SizedBox(width: Insets.s12),
          Expanded(child: _actionButton(label: 'إرسال رسالة', icon: Icons.chat_bubble_outline_rounded)),
        ]),
      ]),
    );
  }

  Widget _actionButton({required String label, required IconData icon}) => SizedBox(
    height: 48.h,
    child: OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 20.sp, color: AppColors.primary),
      label: Text(label, style: getBoldStyle(color: AppColors.primary, fontSize: FontSize.s16)),
      style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primary), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16))),
    ),
  );
}
