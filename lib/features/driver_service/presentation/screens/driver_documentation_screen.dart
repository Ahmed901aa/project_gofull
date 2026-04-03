import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/app_button.dart';

class DriverDocumentationScreen extends StatefulWidget {
  final DriverDocumentationArgs args;
  const DriverDocumentationScreen({super.key, required this.args});

  @override
  State<DriverDocumentationScreen> createState() =>
      _DriverDocumentationScreenState();
}

class _DriverDocumentationScreenState extends State<DriverDocumentationScreen> {
  final _picker = ImagePicker();

  static const _labels = [
    'الجهة الأمامية',
    'الجهة الخلفية',
    'الجهة اليمنى',
    'الجهة اليسرى',
  ];

  final List<File?> _photos = List.filled(4, null);

  int get _capturedCount => _photos.where((p) => p != null).length;
  bool get _allCaptured => _capturedCount == 4;

  bool get _isPickup => widget.args.documentationType == 'pickup';

  String get _buttonLabel =>
      _isPickup ? AppStrings.startToDestination : AppStrings.collectPayment;

  Future<void> _capturePhoto(int index) async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 1280,
    );
    if (picked != null && mounted) {
      setState(() => _photos[index] = File(picked.path));
    }
  }

  void _onContinue() {
    if (_isPickup) {
      Navigator.pushReplacementNamed(
        context,
        Routes.driverNavigate,
        arguments: DriverNavigateArgs(
          orderId: widget.args.orderId,
          address: '',
          navigationType: 'to_destination',
        ),
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        Routes.driverCollectPayment,
        arguments: DriverCollectPaymentArgs(
          orderId: widget.args.orderId,
          amount: 985.00,
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
                    ...List.generate(4, (i) => Padding(
                      padding: EdgeInsets.only(bottom: Insets.s12),
                      child: _buildPhotoCard(i),
                    )),
                    SizedBox(height: Insets.s8),
                    _buildProgressIndicator(),
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
                    AppStrings.mandatoryDocDesc,
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

  // ── Photo Card ──────────────────────────────────────────────

  Widget _buildPhotoCard(int index) {
    final hasPhoto = _photos[index] != null;

    return Container(
      padding: EdgeInsets.all(Insets.s12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.s12),
        border: Border.all(
          color: hasPhoto ? AppColors.success.withOpacity(0.4) : AppColors.inputBorder,
        ),
      ),
      child: Row(
        children: [
          // Text side
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28.w,
                      height: 28.w,
                      decoration: BoxDecoration(
                        color: hasPhoto
                            ? AppColors.success.withOpacity(0.1)
                            : AppColors.neutral300,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: hasPhoto
                            ? Icon(Icons.check_rounded,
                                size: 16.sp, color: AppColors.success)
                            : Text(
                                '${index + 1}',
                                style: getMediumStyle(
                                    color: AppColors.neutral800,
                                    fontSize: FontSize.s12),
                              ),
                      ),
                    ),
                    SizedBox(width: Insets.s8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _labels[index],
                          style: getSemiBoldStyle(
                              color: const Color(0xFF0E0E0E),
                              fontSize: FontSize.s14),
                        ),
                        Text(
                          AppStrings.capturePhoto,
                          style: getRegularStyle(
                              color: AppColors.neutral800,
                              fontSize: FontSize.s12),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Photo / capture button side
          if (hasPhoto)
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.s8),
                  child: Image.file(
                    _photos[index]!,
                    width: 56.w,
                    height: 56.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: Insets.s8),
                GestureDetector(
                  onTap: () => _capturePhoto(index),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Insets.s8, vertical: 6.h),
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
                              color: AppColors.primary,
                              fontSize: FontSize.s12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          else
            GestureDetector(
              onTap: () => _capturePhoto(index),
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Insets.s12, vertical: 8.h),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(AppRadius.s8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt_outlined,
                        size: 16.sp, color: AppColors.primary),
                    SizedBox(width: Insets.s4),
                    Text(
                      AppStrings.capture,
                      style: getMediumStyle(
                          color: AppColors.primary, fontSize: FontSize.s14),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Progress Indicator ──────────────────────────────────────

  Widget _buildProgressIndicator() => Column(
        children: [
          Text(
            '$_capturedCount / 4',
            style: getSemiBoldStyle(
                color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
          ),
          SizedBox(height: Insets.s8),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.s8),
            child: LinearProgressIndicator(
              value: _capturedCount / 4,
              minHeight: 6.h,
              backgroundColor: AppColors.neutral400,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
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
            if (!_allCaptured)
              Padding(
                padding: EdgeInsets.only(bottom: Insets.s8),
                child: Text(
                  AppStrings.captureAllPhotos,
                  style: getRegularStyle(
                      color: AppColors.neutral800, fontSize: FontSize.s12),
                  textAlign: TextAlign.center,
                ),
              ),
            AppButton(
              text: _buttonLabel,
              onPressed: _allCaptured ? _onContinue : () {},
              backgroundColor:
                  _allCaptured ? AppColors.primary : AppColors.neutral600,
            ),
          ],
        ),
      );
}
