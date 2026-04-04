import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/app_button.dart';
import 'package:project_gofull/core/widgets/service_header.dart';

class DriverDocumentationScreen extends StatefulWidget {
  final DriverDocumentationArgs args;
  const DriverDocumentationScreen({super.key, required this.args});

  @override
  State<DriverDocumentationScreen> createState() =>
      _DriverDocumentationScreenState();
}

class _DriverDocumentationScreenState extends State<DriverDocumentationScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<File?> _capturedImages = List.filled(4, null);

  static const List<String> _labels = [
    'الجهة الأمامية',
    'الجهة الخلفية',
    'الجهة اليمنى',
    'الجهة اليسرى',
  ];

  int get _capturedCount => _capturedImages.where((img) => img != null).length;
  bool get _allCaptured => _capturedCount == 4;
  bool get _isPickup => widget.args.documentationType == 'pickup';

  Future<void> _capturePhoto(int index) async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (photo != null) {
      setState(() {
        _capturedImages[index] = File(photo.path);
      });
    }
  }

  void _onContinue() {
    if (_isPickup) {
      Navigator.pushNamed(
        context,
        Routes.driverNavigate,
        arguments: DriverNavigateArgs(
          orderId: widget.args.orderId,
          navigationType: 'to_destination',
          address: 'وجهة التوصيل',
        ),
      );
    } else {
      Navigator.pushNamed(
        context,
        Routes.driverCollectPayment,
        arguments: DriverCollectPaymentArgs(
          orderId: widget.args.orderId,
          amount: 150.0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          const ServiceHeader(title: 'التوثيق'),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(Insets.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInfoCard(),
                  SizedBox(height: Insets.s16),
                  _buildProgressIndicator(),
                  SizedBox(height: Insets.s16),
                  _buildPhotoGrid(),
                  SizedBox(height: Sizes.s48),
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: AppColors.goldLight,
        borderRadius: BorderRadius.circular(AppRadius.s12),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, size: 24.sp, color: AppColors.gold),
          SizedBox(width: Insets.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'توثيق إلزامي',
                  style: getBoldStyle(
                    color: AppColors.black,
                    fontSize: FontSize.s16,
                  ),
                ),
                SizedBox(height: Insets.s4),
                Text(
                  'يرجى التقاط 4 صور واضحة للسيارة من جميع الجهات قبل المتابعة.',
                  style: getRegularStyle(
                    color: AppColors.darkGrey,
                    fontSize: FontSize.s14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$_capturedCount من 4',
          style: getBoldStyle(color: AppColors.primary, fontSize: FontSize.s16),
        ),
        SizedBox(width: Insets.s12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.s8),
            child: LinearProgressIndicator(
              value: _capturedCount / 4,
              minHeight: 8.h,
              backgroundColor: AppColors.neutral400,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: Insets.s12,
        mainAxisSpacing: Insets.s12,
        childAspectRatio: 0.78,
      ),
      itemCount: 4,
      itemBuilder: (context, index) => _buildPhotoCard(index),
    );
  }

  Widget _buildPhotoCard(int index) {
    final hasImage = _capturedImages[index] != null;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.s12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(Insets.s8),
              decoration: BoxDecoration(
                color: hasImage ? null : AppColors.neutral400,
                borderRadius: BorderRadius.circular(AppRadius.s8),
                border: hasImage
                    ? null
                    : Border.all(
                        color: AppColors.grey.withValues(alpha: 0.4),
                        style: BorderStyle.solid,
                      ),
              ),
              child: hasImage
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.s8),
                      child: Image.file(
                        _capturedImages[index]!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.camera_alt_outlined,
                        size: 32.sp,
                        color: AppColors.grey,
                      ),
                    ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Insets.s8),
            child: Text(
              _labels[index],
              style: getMediumStyle(
                color: AppColors.black,
                fontSize: FontSize.s12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(Insets.s8, Insets.s4, Insets.s8, Insets.s8),
            child: SizedBox(
              width: double.infinity,
              height: 32.h,
              child: ElevatedButton(
                onPressed: () => _capturePhoto(index),
                style: ElevatedButton.styleFrom(
                  backgroundColor: hasImage ? AppColors.warning : AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.s8),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  hasImage ? 'إعادة التقاط' : 'التقاط',
                  style: getMediumStyle(
                    color: AppColors.white,
                    fontSize: FontSize.s12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s24),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: AppButton(
        text: _isPickup ? 'بدء التحرك لوجهة التوصيل' : 'تحصيل مبلغ الخدمة',
        backgroundColor: _allCaptured ? AppColors.primary : AppColors.grey,
        onPressed: _allCaptured ? () => _onContinue() : () {},
      ),
    );
  }
}
