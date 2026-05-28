import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/orders/models/order_data.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class ServiceBadge extends StatelessWidget {
  final ServiceType serviceType;
  const ServiceBadge({super.key, required this.serviceType});

  @override
  Widget build(BuildContext context) {
    final label = serviceType == ServiceType.tow ? S.of(context).towTruckService : S.of(context).fuelSupply;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s12, vertical: 4.h),
      decoration: BoxDecoration(color: context.colors.primary, borderRadius: BorderRadius.circular(AppRadius.s16)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          serviceType == ServiceType.tow
              ? SvgPicture.asset('assets/svg/towing.svg', width: 14.sp, height: 14.sp, colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn))
              : Icon(Icons.local_gas_station_outlined, size: 14.sp, color: context.colors.surface),
          SizedBox(width: 4.w),
          Text(label, style: getMediumStyle(color: context.colors.surface, fontSize: FontSize.s12)),
        ],
      ),
    );
  }
}
