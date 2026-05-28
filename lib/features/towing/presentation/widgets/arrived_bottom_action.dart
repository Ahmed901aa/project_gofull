import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class ArrivedBottomAction extends StatelessWidget {
  final int? requestId;
  const ArrivedBottomAction({super.key, this.requestId});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
        boxShadow: const [
          BoxShadow(color: Color(0x0ACCCCCC), blurRadius: 4, offset: Offset(0, -4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, 0),
            child: SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, Routes.rating, (route) => false,
                    arguments: RatingArgs(orderId: (requestId ?? 0).toString())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)),
                  elevation: 0,
                ),
                child: Text(S.of(context).rateService, style: getBoldStyle(color: context.colors.surface, fontSize: FontSize.s16)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(Insets.s16, 8.h, Insets.s16, Insets.s12),
            child: SizedBox(
              width: double.infinity,
              height: 48.h,
              child: TextButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, Routes.home, (route) => false),
                style: TextButton.styleFrom(
                  foregroundColor: context.colors.iconSecondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)),
                ),
                child: Text(S.of(context).skip, style: getRegularStyle(color: context.colors.iconSecondary, fontSize: FontSize.s14)),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
