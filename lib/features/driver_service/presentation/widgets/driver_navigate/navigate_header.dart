import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/directional_icon.dart';

class NavigateHeader extends StatelessWidget {
  final bool isToCustomer;
  final VoidCallback onBack;

  const NavigateHeader({super.key, required this.isToCustomer, required this.onBack});

  String _title(BuildContext context) => isToCustomer
      ? S.of(context).navigateToCustomer
      : S.of(context).navigateToDestination;

  @override
  Widget build(BuildContext context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Container(
          color: context.colors.surface,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              Padding(
                padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: onBack,
                      child: Icon(backArrowIcon(context),
                          size: 24.sp, color: context.colors.textPrimary),
                    ),
                    Expanded(
                      child: Text(
                        _title(context),
                        style: getBoldStyle(
                            color: context.colors.textPrimary, fontSize: FontSize.s20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 24.sp),
                  ],
                ),
              ),
              Divider(height: 1, color: context.colors.borderSubtle),
            ],
          ),
        ),
      );
}
