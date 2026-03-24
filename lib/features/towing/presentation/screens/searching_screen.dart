import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/features/towing/presentation/widgets/searching_animation.dart';
import '../widgets/searching_bottom_panel.dart';
import '../widgets/searching_header.dart';

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
      if (mounted) Navigator.pushReplacementNamed(context, widget.args.nextRoute, arguments: widget.args.nextRouteArgs);
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
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          const SearchingHeader(),
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
          SearchingBottomPanel(secondsLeft: _secondsLeft, progressAnimation: _progressCtrl),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
