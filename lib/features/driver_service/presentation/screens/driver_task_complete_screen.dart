import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/app_button.dart';
import 'package:project_gofull/core/widgets/dotted_circle_container.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class DriverTaskCompleteScreen extends StatelessWidget {
  final DriverTaskCompleteArgs args;
  const DriverTaskCompleteScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.colors.background,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(Insets.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: Sizes.s40),
                    _buildSuccessIcon(),
                    SizedBox(height: Insets.s24),
                    _buildSuccessText(context),
                    SizedBox(height: Sizes.s32),
                    _buildEarningsCard(context),
                    SizedBox(height: Insets.s24),
                  ],
                ),
              ),
            ),
            _buildBottomButton(context),
          ],
        ),
      );
  }

  // ── Header ──────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) => Container(
        color: context.colors.surface,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  Insets.s16, Insets.s12, Insets.s16, Insets.s12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.popUntil(
                        context,
                        (route) =>
                            route.settings.name == Routes.driverHome ||
                            route.isFirst),
                    child: Icon(Icons.close_rounded,
                        size: 24.sp, color: context.colors.textPrimary),
                  ),
                  Expanded(
                    child: Text(
                      S.of(context).taskComplete,
                      style: getBoldStyle(
                          color: context.colors.textPrimary,
                          fontSize: FontSize.s20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Icon(Icons.info_outline_rounded,
                      size: 24.sp, color: context.colors.textPrimary),
                ],
              ),
            ),
            Divider(height: 1, color: context.colors.borderSubtle),
          ],
        ),
      );

  // ── Success Icon ────────────────────────────────────────────

  Widget _buildSuccessIcon() => const Center(
        child: DottedCircleContainer(
          imagePath: 'assets/images/shield.gif',
        ),
      );

  // ── Success Text ────────────────────────────────────────────

  Widget _buildSuccessText(BuildContext context) => Column(
        children: [
          Text(
            S.of(context).orderCompletedSuccess,
            style: getBoldStyle(
                color: context.colors.textPrimary, fontSize: FontSize.s22),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Insets.s8),
          Text(
            S.of(context).earningsRecorded,
            style: getRegularStyle(
                color: context.colors.textSecondary, fontSize: FontSize.s14),
            textAlign: TextAlign.center,
          ),
        ],
      );

  // ── Earnings Card ───────────────────────────────────────────

  Widget _buildEarningsCard(BuildContext context) => Container(
        padding: EdgeInsets.all(Insets.s20),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: context.colors.success.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(
              S.of(context).addedEarnings,
              style: getMediumStyle(
                  color: context.colors.textSecondary, fontSize: FontSize.s14),
            ),
            SizedBox(height: Insets.s8),
            Text(
              '${args.earnings.toStringAsFixed(2)} ${S.of(context).currencyEGP}',
              style: getBoldStyle(
                  color: context.colors.primary, fontSize: FontSize.s28),
            ),
          ],
        ),
      );

  // ── Bottom Button ───────────────────────────────────────────

  Widget _buildBottomButton(BuildContext context) => Container(
        padding: EdgeInsets.fromLTRB(
          Insets.s16,
          Insets.s12,
          Insets.s16,
          Insets.s12 + MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          color: context.colors.surface,
          border: Border(top: BorderSide(color: context.colors.borderSubtle)),
        ),
        child: AppButton(
          text: S.of(context).backToHomeBtn,
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.driverHome,
              (route) => false,
            );
          },
        ),
      );
}
