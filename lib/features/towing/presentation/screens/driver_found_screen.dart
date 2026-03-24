import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/features/towing/presentation/widgets/driver_details_card.dart';
import 'package:project_gofull/features/towing/presentation/widgets/eta_bottom_panel.dart';
import 'package:project_gofull/features/towing/presentation/widgets/gif_circle.dart';
import '../widgets/driver_found_header.dart';

// replace with API data later
const _mockDriver = {
  'name': 'احمد احميد',
  'rating': '4.9',
  'reviewCount': '541',
  'plateNumber': 'أ ب م - 3541',
};

class DriverFoundScreen extends StatefulWidget {
  final DriverFoundArgs? args;
  const DriverFoundScreen({super.key, this.args});

  @override
  State<DriverFoundScreen> createState() => _DriverFoundScreenState();
}

class _DriverFoundScreenState extends State<DriverFoundScreen> {
  static const int _total = 15;
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
    _secondsLeft = _total;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) {
        t.cancel();
        if (_args.nextRoute != null) Navigator.pushReplacementNamed(context, _args.nextRoute!);
      }
    });
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  String get _eta => '${(_secondsLeft ~/ 60).toString().padLeft(2, '0')}:${(_secondsLeft % 60).toString().padLeft(2, '0')}';
  double get _progress => (_total - _secondsLeft) / _total;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          DriverFoundHeader(showClose: _args.showClose),
          Expanded(
            child: Container(
              color: AppColors.scaffoldBg,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GifCircle(imagePath: _args.imagePath ?? 'assets/images/tank_truck.gif'),
                      SizedBox(height: Insets.s16),
                      Text(_args.title, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18), textAlign: TextAlign.center),
                      SizedBox(height: 4.h),
                      Text('وافق السائق على طلبك وهو الآن في طريقه إليك.', style: getRegularStyle(color: AppColors.neutral800, fontSize: FontSize.s14), textAlign: TextAlign.center),
                      SizedBox(height: Insets.s16),
                      DriverDetailsCard(
                        name: _mockDriver['name']!,
                        rating: _mockDriver['rating']!,
                        reviewCount: _mockDriver['reviewCount']!,
                        plateNumber: _mockDriver['plateNumber']!,
                        vehicleLabel: _args.vehicleLabel,
                        vehicleValue: _args.vehicleValue,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          EtaBottomPanel(etaFormatted: _eta, progress: _progress),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
