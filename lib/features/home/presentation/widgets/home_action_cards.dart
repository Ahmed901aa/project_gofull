import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/widgets/directional_icon.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

/// CAFU-style pair of wide gradient action cards:
/// "Fuel now → order to my location" + "Tow truck → roadside assistance".
class HomeActionCards extends StatelessWidget {
  const HomeActionCards({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            title: l10n.fuelNowTitle,
            subtitle: l10n.fuelNowSubtitle,
            icon: Icons.local_gas_station_rounded,
            gradient: [context.colors.primary, context.colors.primaryLight],
            shadowColor: context.colors.primary,
            onTap: () => Navigator.pushNamed(context, Routes.fuelType),
          ),
        ),
        SizedBox(width: Insets.s12),
        Expanded(
          child: _ActionCard(
            title: l10n.searchTowing,
            subtitle: l10n.towNowSubtitle,
            icon: Icons.fire_truck_rounded,
            gradient: const [Color(0xFF37434E), Color(0xFF222B33)],
            shadowColor: const Color(0xFF222B33),
            onTap: () => Navigator.pushNamed(context, Routes.towingRequest),
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final Color shadowColor;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.shadowColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.s20),
        splashColor: AppColors.white.withValues(alpha: 0.12),
        highlightColor: AppColors.white.withValues(alpha: 0.06),
        child: Ink(
          height: 112.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: gradient,
            ),
            borderRadius: BorderRadius.circular(AppRadius.s20),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withValues(alpha: 0.30),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.s20),
            child: Stack(
              children: [
                // Decorative translucent circle (echoes the header style)
                PositionedDirectional(
                  end: -22.w,
                  top: -22.w,
                  child: Container(
                    width: 84.w,
                    height: 84.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(Insets.s12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(icon, color: AppColors.white, size: 26.sp),
                          Container(
                            width: 26.w,
                            height: 26.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white.withValues(alpha: 0.15),
                            ),
                            child: DirectionalServiceIcon(
                              Icons.arrow_forward_rounded,
                              size: 15.sp,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getBoldStyle(
                                color: AppColors.white,
                                fontSize: FontSize.s16),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getRegularStyle(
                                color:
                                    AppColors.white.withValues(alpha: 0.75),
                                fontSize: FontSize.s12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
