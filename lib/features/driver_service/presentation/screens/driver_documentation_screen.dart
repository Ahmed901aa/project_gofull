import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/app_button.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_bloc.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_event.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class DriverDocumentationScreen extends StatefulWidget {
  final DriverDocumentationArgs args;
  const DriverDocumentationScreen({super.key, required this.args});

  @override
  State<DriverDocumentationScreen> createState() =>
      _DriverDocumentationScreenState();
}

class _DriverDocumentationScreenState extends State<DriverDocumentationScreen> {
  final _picker = ImagePicker();

  File? _photo;

  bool get _captured => _photo != null;

  bool get _isPickup => widget.args.documentationType == 'pickup';

  String _buttonLabel(BuildContext context) =>
      _isPickup ? S.of(context).startToDestination : S.of(context).collectPayment;

  Future<void> _capturePhoto() async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 1280,
    );
    if (picked != null && mounted) {
      setState(() => _photo = File(picked.path));
    }
  }

  void _onContinue() {
    final orderId = int.tryParse(widget.args.orderId);

    if (_isPickup) {
      // Update status to 'in_progress' after pickup documentation
      if (orderId != null) {
        sl<ProviderBloc>().add(UpdateStatusEvent(id: orderId, status: 'in_progress'));
      }
      Navigator.pushReplacementNamed(
        context,
        Routes.driverNavigate,
        arguments: DriverNavigateArgs(
          orderId: widget.args.orderId,
          address: '',
          navigationType: 'to_destination',
          amount: widget.args.amount,
        ),
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        Routes.driverCollectPayment,
        arguments: DriverCollectPaymentArgs(
          orderId: widget.args.orderId,
          amount: widget.args.amount,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.colors.background,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(Insets.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildInfoBanner(),
                    SizedBox(height: Insets.s16),
                    _buildPhotoSection(),
                    SizedBox(height: Insets.s24),
                  ],
                ),
              ),
            ),
            _buildBottomSection(context),
          ],
        ),
    );
  }

  // ── Header ──────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) => Container(
        color: context.colors.surface,
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
                        size: 24.sp, color: context.colors.textPrimary),
                  ),
                  Expanded(
                    child: Text(
                      S.of(context).documentation,
                      style: getBoldStyle(
                          color: context.colors.textPrimary,
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
                        color: context.colors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(Icons.phone_rounded,
                          size: 20.sp, color: context.colors.primary),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: context.colors.borderSubtle),
          ],
        ),
      );

  // ── Info Banner ─────────────────────────────────────────────

  Widget _buildInfoBanner() => Container(
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: context.colors.successSurface,
          borderRadius: BorderRadius.circular(AppRadius.s12),
          border: Border.all(color: context.colors.success.withOpacity(0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_rounded, size: 22.sp, color: context.colors.primary),
            SizedBox(width: Insets.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).mandatoryDoc,
                    style: getBoldStyle(
                        color: context.colors.primary, fontSize: FontSize.s14),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    S.of(context).docMandatoryDesc,
                    style: getRegularStyle(
                        color: context.colors.primaryLight,
                        fontSize: FontSize.s12),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  // ── Photo Section ───────────────────────────────────────────

  Widget _buildPhotoSection() {
    return GestureDetector(
      onTap: _capturePhoto,
      child: Container(
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.s12),
          border: Border.all(
            color: _captured
                ? context.colors.success.withValues(alpha: 0.4)
                : context.colors.inputBorder,
          ),
        ),
        child: _captured ? _buildCapturedView() : _buildEmptyView(),
      ),
    );
  }

  Widget _buildEmptyView() => Column(
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.camera_alt_rounded,
                size: 32.sp, color: context.colors.primary),
          ),
          SizedBox(height: Insets.s12),
          Text(
            S.of(context).captureVehiclePhoto,
            style: getSemiBoldStyle(
                color: context.colors.textPrimary, fontSize: FontSize.s16),
          ),
          SizedBox(height: 4.h),
          Text(
            S.of(context).tapToCapturePhoto,
            style: getRegularStyle(
                color: context.colors.textSecondary, fontSize: FontSize.s14),
            textAlign: TextAlign.center,
          ),
        ],
      );

  Widget _buildCapturedView() => Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.s8),
            child: Image.file(
              _photo!,
              width: double.infinity,
              height: 200.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: Insets.s12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_rounded,
                  size: 20.sp, color: context.colors.success),
              SizedBox(width: 6.w),
              Text(
                S.of(context).photoCaptured,
                style: getSemiBoldStyle(
                    color: context.colors.success, fontSize: FontSize.s14),
              ),
              SizedBox(width: Insets.s16),
              GestureDetector(
                onTap: _capturePhoto,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Insets.s12, vertical: 6.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: context.colors.primary),
                    borderRadius: BorderRadius.circular(AppRadius.s8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera_alt_outlined,
                          size: 14.sp, color: context.colors.primary),
                      SizedBox(width: 4.w),
                      Text(
                        S.of(context).retake,
                        style: getMediumStyle(
                            color: context.colors.primary, fontSize: FontSize.s12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );

  // ── Bottom Section ──────────────────────────────────────────

  Widget _buildBottomSection(BuildContext context) => Container(
        padding: EdgeInsets.fromLTRB(
          Insets.s16,
          Insets.s12,
          Insets.s16,
          Insets.s12 + MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          color: context.colors.surface,
          border: Border(top: BorderSide(color: context.colors.borderSubtle)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_captured)
              Padding(
                padding: EdgeInsets.only(bottom: Insets.s8),
                child: Text(
                  S.of(context).pleaseCaptureToContinue,
                  style: getRegularStyle(
                      color: context.colors.textSecondary, fontSize: FontSize.s12),
                  textAlign: TextAlign.center,
                ),
              ),
            AppButton(
              text: _buttonLabel(context),
              onPressed: _captured ? _onContinue : () {},
              backgroundColor:
                  _captured ? context.colors.primary : context.colors.border,
            ),
          ],
        ),
      );
}
