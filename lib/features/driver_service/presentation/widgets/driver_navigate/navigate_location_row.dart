import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class NavigateLocationRow extends StatelessWidget {
  final bool isToCustomer;
  final String address;

  const NavigateLocationRow({super.key, required this.isToCustomer, required this.address});

  String _label(BuildContext context) => isToCustomer
      ? S.of(context).departurePoint
      : S.of(context).deliveryDestinationLabel;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(color: context.colors.primarySurface, shape: BoxShape.circle),
            child: Icon(Icons.location_on_rounded, size: 20.sp, color: context.colors.primary),
          ),
          SizedBox(width: Insets.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _label(context),
                  style: getRegularStyle(
                      color: context.colors.textSecondary, fontSize: FontSize.s12),
                ),
                SizedBox(height: 2.h),
                Text(
                  address,
                  style: getMediumStyle(
                      color: context.colors.textPrimary, fontSize: FontSize.s14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      );
}
