import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

/// Reusable card to display provider info (name, rating, plate, vehicle)
/// across DriverFoundScreen, ServiceArrivedScreen, TripDetailsScreen, etc.
///
/// Data is extracted from a ServiceRequestEntity.providerInfo map which
/// contains the backend provider profile JSON with nested `user` object.
class ProviderInfoCard extends StatelessWidget {
  final String providerName;
  final String rating;
  final String? ratingCount;
  final String plateNumber;
  final String? vehicleModel;
  final String? vehicleMake;
  final VoidCallback? onCall;

  const ProviderInfoCard({
    super.key,
    required this.providerName,
    required this.rating,
    this.ratingCount,
    required this.plateNumber,
    this.vehicleModel,
    this.vehicleMake,
    this.onCall,
  });

  /// Factory constructor that extracts all fields from a ServiceRequestEntity.
  /// Handles null cases gracefully.
  factory ProviderInfoCard.fromRequest(
    ServiceRequestEntity? request, {
    VoidCallback? onCall,
  }) {
    final providerInfo = request?.providerInfo ?? {};
    final user = (providerInfo['user'] as Map<String, dynamic>?) ?? {};

    return ProviderInfoCard(
      providerName: (user['name'] as String?) ?? '',
      rating: (providerInfo['average_rating']?.toString()) ?? '—',
      ratingCount: providerInfo['total_ratings']?.toString(),
      plateNumber: (providerInfo['vehicle_plate'] as String?) ?? '—',
      vehicleModel: providerInfo['vehicle_model'] as String?,
      vehicleMake: providerInfo['vehicle_make'] as String?,
      onCall: onCall,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final displayName = providerName.isEmpty ? l10n.serviceProviderDefault : providerName;
    final vehicleDesc = [
      if (vehicleMake != null && vehicleMake!.isNotEmpty) vehicleMake,
      if (vehicleModel != null && vehicleModel!.isNotEmpty) vehicleModel,
    ].whereType<String>().join(' ');

    return Container(
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: AppColors.neutral500),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFBABABA).withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.providerInfoTitle,
              style: getBoldStyle(
                color: const Color(0xFF0E0E0E),
                fontSize: FontSize.s14,
              ),
            ),
            SizedBox(height: Insets.s12),
            Row(
              children: [
                // Avatar
                Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    size: 30.sp,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: Insets.s12),
                // Name + rating
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: getBoldStyle(
                          color: const Color(0xFF0E0E0E),
                          fontSize: FontSize.s16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 16.sp,
                            color: const Color(0xFFFFB800),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            rating,
                            style: getSemiBoldStyle(
                              color: const Color(0xFF0E0E0E),
                              fontSize: FontSize.s13,
                            ),
                          ),
                          if (ratingCount != null &&
                              ratingCount!.isNotEmpty &&
                              ratingCount != '0') ...[
                            SizedBox(width: 4.w),
                            Text(
                              l10n.ratingCountLabel(ratingCount!),
                              style: getRegularStyle(
                                color: AppColors.neutral800,
                                fontSize: FontSize.s12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // Call button
                if (onCall != null)
                  GestureDetector(
                    onTap: onCall,
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.s12),
                      ),
                      child: Icon(
                        Icons.phone_rounded,
                        size: 20.sp,
                        color: AppColors.white,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: Insets.s12),
            const Divider(height: 1, color: AppColors.neutral500),
            SizedBox(height: Insets.s12),
            // Plate + vehicle
            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    icon: Icons.credit_card_rounded,
                    label: l10n.carPlate,
                    value: plateNumber,
                  ),
                ),
                if (vehicleDesc.isNotEmpty) ...[
                  SizedBox(width: Insets.s12),
                  Expanded(
                    child: _InfoItem(
                      icon: Icons.directions_car_rounded,
                      label: l10n.vehicleInfo,
                      value: vehicleDesc,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Insets.s8),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(AppRadius.s12),
        border: Border.all(color: AppColors.neutral500),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14.sp, color: AppColors.primary),
              SizedBox(width: 4.w),
              Text(
                label,
                style: getRegularStyle(
                  color: AppColors.neutral800,
                  fontSize: FontSize.s12,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: getBoldStyle(
              color: const Color(0xFF0E0E0E),
              fontSize: FontSize.s13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
