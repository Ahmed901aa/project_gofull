import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/features/towing/presentation/widgets/searching_animation.dart';

class SearchingScreen extends StatefulWidget {
  final SearchingArgs args;
  const SearchingScreen({super.key, required this.args});
  @override
  State<SearchingScreen> createState() => _SearchingScreenState();
}

class _SearchingScreenState extends State<SearchingScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _progressCtrl;
  late final Timer _navTimer;
  int _secondsLeft = 5;

  @override
  void initState() {
    super.initState();
    _progressCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 5))..forward();
    Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) t.cancel();
    });
    _navTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) Navigator.pushReplacementNamed(context, widget.args.nextRoute);
    });
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    _navTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SearchingAnimation(),
                    SizedBox(height: Insets.s16),
                    Text(widget.args.searchingText, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18), textAlign: TextAlign.center),
                    SizedBox(height: Insets.s8),
                    Text(widget.args.subtitleText, style: getRegularStyle(color: AppColors.neutral800, fontSize: FontSize.s14), textAlign: TextAlign.center),
                    SizedBox(height: Insets.s16),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
                      decoration: BoxDecoration(color: AppColors.primary50, borderRadius: BorderRadius.circular(AppRadius.s16), border: Border.all(color: AppColors.primary)),
                      child: Text('يرجى الانتظار في مكان آمن بعيداً عن حركة المرور وتشغيل أضواء التنبيه في سيارتك حتى وصول السائق.', style: getRegularStyle(color: AppColors.primary, fontSize: FontSize.s14), textAlign: TextAlign.right),
                    ),
                  ],
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Column(children: [
        SizedBox(height: MediaQuery.of(context).padding.top),
        Padding(
          padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.close_rounded, size: 24.sp, color: const Color(0xFF0E0E0E))),
            Text('تأكيد الطلب', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20)),
            const SizedBox(width: 24),
          ]),
        ),
        const Divider(height: 1, color: Color(0xFFF5F5F5)),
      ]),
    );
  }

  Widget _buildBottomPanel(BuildContext context) {
    final mm = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final ss = (_secondsLeft % 60).toString().padLeft(2, '0');
    return Container(
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)), boxShadow: [BoxShadow(color: const Color(0xFFCCCCCC).withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, -2))]),
      padding: EdgeInsets.all(Insets.s16),
      child: Column(children: [
        RichText(textDirection: TextDirection.rtl, text: TextSpan(children: [
          TextSpan(text: 'الوقت المتوقع للعثور على سائق: ', style: getRegularStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14)),
          TextSpan(text: '$mm:$ss دقيقة', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14)),
        ])),
        SizedBox(height: Insets.s8),
        AnimatedBuilder(
          animation: _progressCtrl,
          builder: (_, __) => Container(
            height: 6.h, decoration: BoxDecoration(color: const Color(0xFFD9DADB), borderRadius: BorderRadius.circular(AppRadius.s16)),
            child: FractionallySizedBox(widthFactor: _progressCtrl.value, alignment: Alignment.centerRight,
              child: Container(decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppRadius.s16))),
            ),
          ),
        ),
        SizedBox(height: Insets.s16),
        SizedBox(
          height: 48.h, width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close_rounded, size: 20.sp, color: AppColors.primary),
            label: Text('إلغاء الطلب', style: getBoldStyle(color: AppColors.primary, fontSize: FontSize.s16)),
            style: OutlinedButton.styleFrom(side: BorderSide(color: AppColors.primary), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16))),
          ),
        ),
      ]),
    );
  }
}
