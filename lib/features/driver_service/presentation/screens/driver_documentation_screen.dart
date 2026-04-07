import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/app_button.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_bloc.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_event.dart';

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

  String get _buttonLabel =>
      _isPickup ? AppStrings.startToDestination : AppStrings.collectPayment;

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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
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
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────

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
                      AppStrings.documentation,
                      style: getBoldStyle(
                          color: const Color(0xFF0E0E0E),
                          fontSize: FontSize.s20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Icon(Icons.info_outline_rounded,
                      size: 24.sp, color: const Color(0xFF0E0E0E)),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF5F5F5)),
          ],
        ),
      );

  // ── Info Banner ─────────────────────────────────────────────

  Widget _buildInfoBanner() => Container(
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(AppRadius.s12),
          border: Border.all(color: AppColors.success.withOpacity(0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_rounded, size: 22.sp, color: AppColors.primary),
            SizedBox(width: Insets.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.mandatoryDoc,
                    style: getBoldStyle(
                        color: AppColors.primary, fontSize: FontSize.s14),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'التقط صورة واضحة للمركبة قبل بدء عملية النقل. هذا التوثيق يحمي حقوقك وحقوق العميل.',
                    style: getRegularStyle(
                        color: AppColors.primaryLight,
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
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.s12),
          border: Border.all(
            color: _captured
                ? AppColors.success.withValues(alpha: 0.4)
                : AppColors.inputBorder,
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
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.camera_alt_rounded,
                size: 32.sp, color: AppColors.primary),
          ),
          SizedBox(height: Insets.s12),
          Text(
            'التقط صورة للمركبة',
            style: getSemiBoldStyle(
                color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
          ),
          SizedBox(height: 4.h),
          Text(
            'اضغط هنا لفتح الكاميرا والتقاط صورة واضحة',
            style: getRegularStyle(
                color: AppColors.neutral800, fontSize: FontSize.s14),
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
                  size: 20.sp, color: AppColors.success),
              SizedBox(width: 6.w),
              Text(
                'تم التقاط الصورة',
                style: getSemiBoldStyle(
                    color: AppColors.success, fontSize: FontSize.s14),
              ),
              SizedBox(width: Insets.s16),
              GestureDetector(
                onTap: _capturePhoto,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Insets.s12, vertical: 6.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(AppRadius.s8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera_alt_outlined,
                          size: 14.sp, color: AppColors.primary),
                      SizedBox(width: 4.w),
                      Text(
                        AppStrings.retake,
                        style: getMediumStyle(
                            color: AppColors.primary, fontSize: FontSize.s12),
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
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: Color(0xFFF5F5F5))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_captured)
              Padding(
                padding: EdgeInsets.only(bottom: Insets.s8),
                child: Text(
                  'يرجى التقاط صورة للمركبة للمتابعة',
                  style: getRegularStyle(
                      color: AppColors.neutral800, fontSize: FontSize.s12),
                  textAlign: TextAlign.center,
                ),
              ),
            AppButton(
              text: _buttonLabel,
              onPressed: _captured ? _onContinue : () {},
              backgroundColor:
                  _captured ? AppColors.primary : AppColors.neutral600,
            ),
          ],
        ),
      );
}
