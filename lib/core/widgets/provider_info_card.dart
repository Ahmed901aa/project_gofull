import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/utils/vehicle_translator.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

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

  /// Whether to render the "Provider Information" title inside the card.
  /// Set to `false` when the caller already provides a section title above
  /// the card to avoid duplicated headings.
  final bool showTitle;

  const ProviderInfoCard({
    super.key,
    required this.providerName,
    required this.rating,
    this.ratingCount,
    required this.plateNumber,
    this.vehicleModel,
    this.vehicleMake,
    this.onCall,
    this.showTitle = true,
  });

  /// Factory constructor that extracts all fields from a ServiceRequestEntity.
  /// Handles null cases gracefully.
  factory ProviderInfoCard.fromRequest(
    ServiceRequestEntity? request, {
    VoidCallback? onCall,
    bool showTitle = true,
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
      showTitle: showTitle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final displayName = providerName.isEmpty ? l10n.serviceProviderDefault : providerName;
    final vehicleDesc = VehicleTranslator.localizeMakeModel(
      context,
      make: vehicleMake,
      model: vehicleModel,
    );

    return Container(
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: context.colors.border),
          boxShadow: [
            BoxShadow(
              color: context.colors.textDisabled.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showTitle) ...[
              Text(
                l10n.providerInfoTitle,
                style: getBoldStyle(
                  color: context.colors.textPrimary,
                  fontSize: FontSize.s14,
                ),
              ),
              SizedBox(height: Insets.s12),
            ],
            Row(
              children: [
                // Avatar
                Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    color: context.colors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    size: 30.sp,
                    color: context.colors.primary,
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
                          color: context.colors.textPrimary,
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
                            color: context.colors.gold,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            rating,
                            style: getSemiBoldStyle(
                              color: context.colors.textPrimary,
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
                                color: context.colors.textSecondary,
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
                        color: context.colors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.s12),
                      ),
                      child: Icon(
                        Icons.phone_rounded,
                        size: 20.sp,
                        color: context.colors.surface,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: Insets.s12),
            Divider(height: 1, color: context.colors.border),
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
        color: context.colors.background,
        borderRadius: BorderRadius.circular(AppRadius.s12),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14.sp, color: context.colors.primary),
              SizedBox(width: 4.w),
              Text(
                label,
                style: getRegularStyle(
                  color: context.colors.textSecondary,
                  fontSize: FontSize.s12,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: getBoldStyle(
              color: context.colors.textPrimary,
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
