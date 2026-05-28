import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/resources/assets_manager.dart';
import 'package:project_gofull/core/widgets/app_header.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

class DriverPrivacyPolicyScreen extends StatelessWidget {
  const DriverPrivacyPolicyScreen({super.key});

  static List<_PolicySection> _buildSections(BuildContext context) {
    final l10n = S.of(context);
    return [
      _PolicySection(
        icon: Icons.info_outline_rounded,
        title: l10n.privacyPolicyIntroTitle,
        body: l10n.privacyDriverIntroBody,
      ),
      _PolicySection(
        icon: Icons.folder_outlined,
        title: l10n.privacyDriverDataCollectedTitle,
        body: l10n.privacyDriverDataCollectedBody,
      ),
      _PolicySection(
        icon: Icons.settings_outlined,
        title: l10n.privacyDriverDataUseTitle,
        body: l10n.privacyDriverDataUseBody,
      ),
      _PolicySection(
        icon: Icons.share_outlined,
        title: l10n.privacyDriverDataShareTitle,
        body: l10n.privacyDriverDataShareBody,
      ),
      _PolicySection(
        icon: Icons.shield_outlined,
        title: l10n.privacyDriverDataProtectionTitle,
        body: l10n.privacyDriverDataProtectionBody,
      ),
      _PolicySection(
        icon: Icons.location_on_outlined,
        title: l10n.privacyDriverLocationTitle,
        body: l10n.privacyDriverLocationBody,
      ),
      _PolicySection(
        icon: Icons.gavel_outlined,
        title: l10n.privacyDriverRightsTitle,
        body: l10n.privacyDriverRightsBody,
      ),
      _PolicySection(
        icon: Icons.headset_mic_outlined,
        title: l10n.privacyDriverContactTitle,
        body: l10n.privacyDriverContactBody,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: Column(
          children: [
            AppHeader(title: S.of(context).privacyPolicyTitle),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(Insets.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // App info card
                    Container(
                      padding: EdgeInsets.all(Insets.s16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1A6B54), Color(0xFF004B3B)],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.s16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 56.w,
                            height: 56.w,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1.2,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.w),
                              child: Image.asset(
                                ImageAssets.logo,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(width: Insets.s12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'GO FULL — ${S.of(context).privacyPolicyTitle}',
                                  style: getBoldStyle(
                                    color: AppColors.white,
                                    fontSize: FontSize.s16,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  S.of(context).privacyLastUpdate,
                                  style: getRegularStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: FontSize.s12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Policy sections
                    ..._buildSections(context).asMap().entries.expand((entry) => [
                      _SectionCard(
                        section: entry.value,
                        index: entry.key,
                      ),
                      SizedBox(height: 12.h),
                    ]),

                    SizedBox(height: 8.h),

                    // Footer
                    Center(
                      child: Text(
                        S.of(context).privacyCopyright,
                        style: getRegularStyle(
                          color: AppColors.grey,
                          fontSize: FontSize.s12,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final _PolicySection section;
  final int index;

  const _SectionCard({
    required this.section,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.s12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  section.icon,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: Insets.s10),
              Expanded(
                child: Text(
                  section.title,
                  style: getBoldStyle(
                    color: const Color(0xFF0E0E0E),
                    fontSize: FontSize.s16,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            section.body,
            style: getRegularStyle(
              color: AppColors.darkGrey,
              fontSize: FontSize.s14,
            ).copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _PolicySection {
  final IconData icon;
  final String title;
  final String body;
  const _PolicySection({
    required this.icon,
    required this.title,
    required this.body,
  });
}
