import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'driver_avatar.dart';
import 'rating_badge.dart';
import 'info_pill.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class DriverDetailsCard extends StatelessWidget {
  final String name;
  final String rating;
  final String reviewCount;
  final String plateNumber;
  final String vehicleLabel;
  final String vehicleValue;
  final bool showActionIcons;
  final VoidCallback? onCall;
  final VoidCallback? onMessage;

  const DriverDetailsCard({
    super.key,
    required this.name,
    required this.rating,
    required this.reviewCount,
    required this.plateNumber,
    required this.vehicleLabel,
    required this.vehicleValue,
    this.showActionIcons = false,
    this.onCall,
    this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(Insets.s16, Insets.s12, Insets.s16, 0),
          child: Row(
            mainAxisAlignment: showActionIcons ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
            children: [
              Expanded(
                child: Row(children: [
                  const DriverAvatar(),
                  SizedBox(width: Insets.s12),
                  Flexible(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(name, style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s16), maxLines: 1, overflow: TextOverflow.ellipsis),
                      SizedBox(height: 4.h),
                      RatingBadge(rating: rating, reviewCount: reviewCount),
                    ]),
                  ),
                ]),
              ),
              if (showActionIcons)
                Row(children: [
                  GestureDetector(
                    onTap: onCall,
                    child: const _ActionIcon(icon: Icons.call_rounded),
                  ),
                  SizedBox(width: Insets.s12),
                  GestureDetector(
                    onTap: onMessage,
                    child: const _ActionIcon(icon: Icons.chat_bubble_outline_rounded),
                  ),
                ]),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(Insets.s16, 0, Insets.s16, Insets.s12),
          child: Row(children: [
            InfoPill(label: vehicleLabel, value: vehicleValue),
            SizedBox(width: Insets.s16),
            InfoPill(label: S.of(context).plateNumber, value: plateNumber),
          ]),
        ),
      ]),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  const _ActionIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.w, height: 32.w,
      decoration: BoxDecoration(color: context.colors.surface, borderRadius: BorderRadius.circular(AppRadius.s16)),
      child: Icon(icon, size: 16.sp, color: context.colors.primary),
    );
  }
}
