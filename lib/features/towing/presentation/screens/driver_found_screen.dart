import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/features/towing/presentation/widgets/eta_bottom_panel.dart';
import '../widgets/driver_found_body.dart';
import '../widgets/driver_found_header.dart';

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
        if (_args.nextRoute != null) Navigator.pushReplacementNamed(context, _args.nextRoute!, arguments: _args.nextRouteArgs);
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
            child: DriverFoundBody(
              title: _args.title,
              driverName: _mockDriver['name']!,
              driverRating: _mockDriver['rating']!,
              driverReviewCount: _mockDriver['reviewCount']!,
              driverPlateNumber: _mockDriver['plateNumber']!,
              vehicleLabel: _args.vehicleLabel,
              vehicleValue: _args.vehicleValue,
            ),
          ),
          EtaBottomPanel(etaFormatted: _eta, progress: _progress),
          // TODO: Remove this mock button — in production, the driver app triggers
          // navigation when the driver confirms they have arrived at the user's location.
          if (_args.nextRoute != null)
            _MockTriggerButton(
              label: 'محاكاة: وصول مزود الخدمة',
              onTap: () {
                _timer?.cancel();
                Navigator.pushReplacementNamed(context, _args.nextRoute!, arguments: _args.nextRouteArgs);
              },
            ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

// ── Mock trigger button (REMOVE IN PRODUCTION) ────────────────────────────────
class _MockTriggerButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _MockTriggerButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.fromLTRB(Insets.s16, 0, Insets.s16, Insets.s12),
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.warning,
          side: const BorderSide(color: AppColors.warning),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)),
          minimumSize: Size(double.infinity, 44.h),
        ),
        child: Text(label, style: getBoldStyle(color: AppColors.warning, fontSize: FontSize.s14)),
      ),
    );
  }
}
