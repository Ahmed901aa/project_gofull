import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/app_button.dart';
import 'package:project_gofull/core/widgets/dotted_circle_container.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_bloc.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_event.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverRefuelingArgs {
  final String orderId;
  final double amount;
  final String? customerPhone;
  const DriverRefuelingArgs({required this.orderId, required this.amount, this.customerPhone});
}

class DriverRefuelingScreen extends StatefulWidget {
  final DriverRefuelingArgs args;
  const DriverRefuelingScreen({super.key, required this.args});

  @override
  State<DriverRefuelingScreen> createState() => _DriverRefuelingScreenState();
}

class _DriverRefuelingScreenState extends State<DriverRefuelingScreen> {

  void _onRefuelingDone() {
    final orderId = int.tryParse(widget.args.orderId);
    if (orderId != null) {
      sl<ProviderBloc>().add(UpdateStatusEvent(id: orderId, status: 'in_progress'));
    }
    Navigator.pushReplacementNamed(
      context,
      Routes.driverCollectPayment,
      arguments: DriverCollectPaymentArgs(
        orderId: widget.args.orderId,
        amount: widget.args.amount,
        customerPhone: widget.args.customerPhone,
      );
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
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(Insets.s16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: Insets.s16),
                      const DottedCircleContainer(
                          imagePath: 'assets/images/refuel.gif'),
                      SizedBox(height: Insets.s24),
                      Text(
                        S.of(context).refuelingInProgressTitle,
                        style: getBoldStyle(
                          color: const Color(0xFF0E0E0E),
                          fontSize: FontSize.s22,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        S.of(context).refuelingInstructions,
                        style: getRegularStyle(
                          color: AppColors.neutral800,
                          fontSize: FontSize.s14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: Insets.s24),
                      _buildInstructionsCard(),
                      SizedBox(height: Insets.s16),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
        color: AppColors.white,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  Insets.s16, Insets.s12, Insets.s16, Insets.s12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_rounded,
                        size: 24.sp, color: const Color(0xFF0E0E0E)),
                  ),
                  Expanded(
                    child: Text(
                      S.of(context).refuelingTitle,
                      style: getBoldStyle(
                          color: const Color(0xFF0E0E0E),
                          fontSize: FontSize.s20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      final phone = widget.args.customerPhone;
                      if (phone != null && phone.isNotEmpty) {
                        launchUrl(Uri.parse('tel:$phone'));
                      }
                    },
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(Icons.phone_rounded,
                          size: 20.sp, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF5F5F5)),
          ],
        ),
      );

  Widget _buildInstructionsCard() => Container(
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(AppRadius.s12),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_rounded, size: 22.sp, color: AppColors.primary),
                SizedBox(width: Insets.s8),
                Text(
                  S.of(context).refuelingGuide,
                  style: getBoldStyle(
                      color: AppColors.primary, fontSize: FontSize.s14),
                ),
              ],
            ),
            SizedBox(height: Insets.s12),
            _bulletPoint(S.of(context).refuelingStep1),
            SizedBox(height: Insets.s8),
            _bulletPoint(S.of(context).refuelingStep2),
            SizedBox(height: Insets.s8),
            _bulletPoint(S.of(context).refuelingStep3),
          ],
        ),
      );

  Widget _bulletPoint(String text) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Container(
              width: 6.w,
              height: 6.w,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: Insets.s8),
          Expanded(
            child: Text(
              text,
              style: getRegularStyle(
                  color: AppColors.primaryLight, fontSize: FontSize.s14),
            ),
          ),
        ],
      );

  Widget _buildBottomButton(BuildContext context) => Container(
        padding: EdgeInsets.fromLTRB(
          Insets.s16,
          Insets.s12,
          Insets.s16,
          Insets.s12 + MediaQuery.of(context).padding.bottom,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: Color(0xFFF5F5F5))),
        ),
        child: AppButton(
          text: S.of(context).refuelingDoneCollect,
          onPressed: _onRefuelingDone,
        ),
      );
}
