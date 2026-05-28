import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/app_button.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_bloc.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_event.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class DriverRateCustomerScreen extends StatefulWidget {
  final DriverRateArgs args;
  const DriverRateCustomerScreen({super.key, required this.args});

  @override
  State<DriverRateCustomerScreen> createState() =>
      _DriverRateCustomerScreenState();
}

class _DriverRateCustomerScreenState extends State<DriverRateCustomerScreen> {
  int _selectedStars = 0;
  final _notesController = TextEditingController();
  static const int _maxChars = 80;

  bool get _showNotesField => _selectedStars >= 4;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    // Send rating to backend
    final orderId = int.tryParse(widget.args.orderId);
    if (orderId != null) {
      sl<ProviderBloc>().add(RateDriverEvent(
        requestId: orderId,
        rating: _selectedStars,
        comment: _notesController.text.isNotEmpty ? _notesController.text : null,
      ));
    }
    // Navigate back to driver home
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.driverHome,
      (route) => false,
    );
  }

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
                    SizedBox(height: Sizes.s24),
                    _buildQuestion(),
                    SizedBox(height: Sizes.s32),
                    _buildStars(),
                    SizedBox(height: Sizes.s32),
                    if (_showNotesField) ...[
                      _buildNotesField(),
                      SizedBox(height: Insets.s24),
                    ],
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
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_rounded,
                        size: 24.sp, color: context.colors.textPrimary),
                  ),
                  Expanded(
                    child: Text(
                      S.of(context).rateTrip,
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

  // ── Question ────────────────────────────────────────────────

  Widget _buildQuestion() => Column(
        children: [
          Text(
            S.of(context).howWasCustomer,
            style: getBoldStyle(
                color: context.colors.textPrimary, fontSize: FontSize.s20),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Insets.s8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Insets.s16),
            child: Text(
              S.of(context).ratingHelps,
              style: getRegularStyle(
                  color: context.colors.textSecondary, fontSize: FontSize.s14),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );

  // ── Stars ───────────────────────────────────────────────────

  Widget _buildStars() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          final starIndex = index + 1;
          final isSelected = starIndex <= _selectedStars;
          return GestureDetector(
            onTap: () => setState(() => _selectedStars = starIndex),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Icon(
                isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
                size: 44.sp,
                color: isSelected ? context.colors.gold : context.colors.border,
              ),
            ),
          );
        }),
      );

  // ── Notes Field ─────────────────────────────────────────────

  Widget _buildNotesField() => Container(
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.s12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).additionalNotes,
              style: getSemiBoldStyle(
                  color: context.colors.textPrimary, fontSize: FontSize.s16),
            ),
            SizedBox(height: Insets.s12),
            TextField(
              controller: _notesController,
              maxLength: _maxChars,
              maxLines: 3,
              onChanged: (_) => setState(() {}),
              style: getRegularStyle(
                  color: context.colors.textPrimary, fontSize: FontSize.s14),
              decoration: InputDecoration(
                hintText: S.of(context).additionalNotesHint,
                hintStyle: getRegularStyle(
                    color: context.colors.textSecondary, fontSize: FontSize.s14),
                filled: true,
                fillColor: context.colors.surfaceVariant,
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.s8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.all(Insets.s12),
              ),
            ),
            SizedBox(height: Insets.s4),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                '${_notesController.text.length}/$_maxChars',
                style: getRegularStyle(
                    color: context.colors.textSecondary, fontSize: FontSize.s12),
              ),
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
          text: S.of(context).submitRating,
          onPressed: _selectedStars > 0 ? _onSubmit : () {},
          backgroundColor:
              _selectedStars > 0 ? context.colors.primary : context.colors.border,
        ),
      );
}
