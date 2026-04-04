import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/service_header.dart';

enum _DocStatus { underReview, accepted, required_ }

class _DocumentItem {
  final String name;
  final _DocStatus status;
  const _DocumentItem({required this.name, required this.status});
}

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  static const _driverName = 'محمود عبدالعليم';
  static const _driverId = 'ID-4055';
  static const _isActive = true;
  static const _ratingValue = '4.8';
  static const _joinYear = '2024';
  static const _salary = '1500 د.ك';
  static const _vehicleTypeName = AppStrings.hydraulicWinch;
  static const _plateNumberValue = 'أ ب م - 3541';

  static const List<_DocumentItem> _documents = [
    _DocumentItem(name: AppStrings.nationalId, status: _DocStatus.underReview),
    _DocumentItem(name: AppStrings.drivingLicense, status: _DocStatus.accepted),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          const ServiceHeader(title: AppStrings.driverProfile),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(Insets.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProfileCard(),
                  SizedBox(height: Sizes.s16),
                  _buildStatsRow(),
                  SizedBox(height: Sizes.s16),
                  _buildSalarySection(),
                  SizedBox(height: Sizes.s16),
                  _buildVehicleSection(),
                  SizedBox(height: Sizes.s16),
                  _buildDocumentsSection(),
                  SizedBox(height: Sizes.s32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: EdgeInsets.all(Insets.s16),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 40.r,
                backgroundColor: AppColors.neutral300,
                child: Icon(
                  Icons.person,
                  size: 44.sp,
                  color: AppColors.grey,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
                    child: Icon(
                      Icons.edit,
                      size: 14.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: Insets.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _driverName,
                  style: getBoldStyle(
                    color: AppColors.black,
                    fontSize: FontSize.s18,
                  ),
                ),
                SizedBox(height: Sizes.s4),
                Text(
                  _driverId,
                  style: getRegularStyle(
                    color: AppColors.grey,
                    fontSize: FontSize.s14,
                  ),
                ),
                SizedBox(height: Sizes.s4),
                Text(
                  AppStrings.towDriver,
                  style: getMediumStyle(
                    color: AppColors.neutral800,
                    fontSize: FontSize.s14,
                  ),
                ),
                SizedBox(height: Sizes.s8),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Insets.s12,
                    vertical: Insets.s4,
                  ),
                  decoration: BoxDecoration(
                    color: _isActive
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.s24),
                  ),
                  child: Text(
                    _isActive ? AppStrings.active : AppStrings.inactive,
                    style: getMediumStyle(
                      color: _isActive ? AppColors.success : AppColors.error,
                      fontSize: FontSize.s12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            label: AppStrings.rating,
            value: _ratingValue,
            icon: Icons.star_rounded,
            iconColor: AppColors.gold,
          ),
        ),
        SizedBox(width: Insets.s12),
        Expanded(
          child: _statCard(
            label: AppStrings.joinDate,
            value: '${AppStrings.since} $_joinYear',
            icon: Icons.calendar_today_outlined,
            iconColor: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.all(Insets.s16),
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
          Icon(icon, size: 24.sp, color: iconColor),
          SizedBox(height: Sizes.s8),
          Text(
            value,
            style: getBoldStyle(
              color: AppColors.black,
              fontSize: FontSize.s18,
            ),
          ),
          SizedBox(height: Sizes.s4),
          Text(
            label,
            style: getRegularStyle(
              color: AppColors.grey,
              fontSize: FontSize.s12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.salary,
          style: getBoldStyle(
            color: AppColors.black,
            fontSize: FontSize.s18,
          ),
        ),
        SizedBox(height: Sizes.s8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(Insets.s16),
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
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.s8),
                ),
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 22.sp,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: Insets.s12),
              Expanded(
                child: Text(
                  '${AppStrings.fixedSalary}: $_salary',
                  style: getMediumStyle(
                    color: AppColors.black,
                    fontSize: FontSize.s16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.vehicle,
          style: getBoldStyle(
            color: AppColors.black,
            fontSize: FontSize.s18,
          ),
        ),
        SizedBox(height: Sizes.s8),
        Row(
          children: [
            Expanded(
              child: _vehicleInfoCard(
                label: AppStrings.vehicleType,
                value: _vehicleTypeName,
                icon: Icons.local_shipping_outlined,
              ),
            ),
            SizedBox(width: Insets.s12),
            Expanded(
              child: _vehicleInfoCard(
                label: AppStrings.plateNumber,
                value: _plateNumberValue,
                icon: Icons.confirmation_number_outlined,
              ),
            ),
          ],
        ),
        SizedBox(height: Sizes.s12),
        Container(
          width: double.infinity,
          height: 160.h,
          decoration: BoxDecoration(
            color: AppColors.neutral300,
            borderRadius: BorderRadius.circular(AppRadius.s12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_shipping_outlined,
                size: 48.sp,
                color: AppColors.grey,
              ),
              SizedBox(height: Sizes.s8),
              Text(
                'صورة المركبة',
                style: getRegularStyle(
                  color: AppColors.grey,
                  fontSize: FontSize.s14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _vehicleInfoCard({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(Insets.s12),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.sp, color: AppColors.primary),
          SizedBox(height: Sizes.s8),
          Text(
            label,
            style: getRegularStyle(
              color: AppColors.grey,
              fontSize: FontSize.s12,
            ),
          ),
          SizedBox(height: Sizes.s4),
          Text(
            value,
            style: getMediumStyle(
              color: AppColors.black,
              fontSize: FontSize.s14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.documents,
          style: getBoldStyle(
            color: AppColors.black,
            fontSize: FontSize.s18,
          ),
        ),
        SizedBox(height: Sizes.s8),
        Container(
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
            children: List.generate(_documents.length, (index) {
              final doc = _documents[index];
              return Column(
                children: [
                  if (index > 0)
                    Divider(
                      height: 1,
                      color: AppColors.divider,
                      indent: Insets.s16,
                      endIndent: Insets.s16,
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Insets.s16,
                      vertical: Insets.s12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: BoxDecoration(
                            color: AppColors.neutral300,
                            borderRadius: BorderRadius.circular(AppRadius.s8),
                          ),
                          child: Icon(
                            Icons.description_outlined,
                            size: 20.sp,
                            color: AppColors.grey,
                          ),
                        ),
                        SizedBox(width: Insets.s12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doc.name,
                                style: getMediumStyle(
                                  color: AppColors.black,
                                  fontSize: FontSize.s14,
                                ),
                              ),
                              SizedBox(height: Sizes.s4),
                              _buildDocStatusBadge(doc.status),
                            ],
                          ),
                        ),
                        _buildDocAction(doc.status),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildDocStatusBadge(_DocStatus status) {
    late String text;
    late Color color;
    late Color bgColor;

    switch (status) {
      case _DocStatus.underReview:
        text = AppStrings.underReview;
        color = AppColors.warning;
        bgColor = AppColors.warning.withValues(alpha: 0.1);
        break;
      case _DocStatus.accepted:
        text = AppStrings.accepted;
        color = AppColors.success;
        bgColor = AppColors.success.withValues(alpha: 0.1);
        break;
      case _DocStatus.required_:
        text = AppStrings.required_;
        color = AppColors.error;
        bgColor = AppColors.error.withValues(alpha: 0.1);
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Insets.s8,
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.s8),
      ),
      child: Text(
        text,
        style: getMediumStyle(color: color, fontSize: FontSize.s12),
      ),
    );
  }

  Widget _buildDocAction(_DocStatus status) {
    final isUpload = status == _DocStatus.required_;
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Insets.s12,
          vertical: Insets.s4,
        ),
        decoration: BoxDecoration(
          color: isUpload ? AppColors.primary : AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.s8),
        ),
        child: Text(
          isUpload ? AppStrings.uploadFile : AppStrings.view,
          style: getMediumStyle(
            color: isUpload ? AppColors.white : AppColors.primary,
            fontSize: FontSize.s12,
          ),
        ),
      ),
    );
  }
}
