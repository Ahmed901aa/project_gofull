import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/app_button.dart';

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
    // Navigate back to driver home
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.driverHome,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
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
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) => Container(
        color: AppColors.white,
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
                        size: 24.sp, color: const Color(0xFF0E0E0E)),
                  ),
                  Expanded(
                    child: Text(
                      AppStrings.rateTrip,
                      style: getBoldStyle(
                          color: const Color(0xFF0E0E0E),
                          fontSize: FontSize.s20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Icon(Icons.info_outline_rounded,
                      size: 24.sp, color: const Color(0xFF0E0E0E)),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF5F5F5)),
          ],
        ),
      );

  // ── Question ────────────────────────────────────────────────

  Widget _buildQuestion() => Column(
        children: [
          Text(
            AppStrings.howWasCustomer,
            style: getBoldStyle(
                color: const Color(0xFF0E0E0E), fontSize: FontSize.s20),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Insets.s8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Insets.s16),
            child: Text(
              AppStrings.ratingHelps,
              style: getRegularStyle(
                  color: AppColors.neutral800, fontSize: FontSize.s14),
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
                color: isSelected ? AppColors.gold : AppColors.neutral600,
              ),
            ),
          );
        }),
      );

  // ── Notes Field ─────────────────────────────────────────────

  Widget _buildNotesField() => Container(
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.s12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.additionalNotes,
              style: getSemiBoldStyle(
                  color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
            ),
            SizedBox(height: Insets.s12),
            TextField(
              controller: _notesController,
              maxLength: _maxChars,
              maxLines: 3,
              onChanged: (_) => setState(() {}),
              style: getRegularStyle(
                  color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
              decoration: InputDecoration(
                hintText: AppStrings.additionalNotesHint,
                hintStyle: getRegularStyle(
                    color: AppColors.neutral800, fontSize: FontSize.s14),
                filled: true,
                fillColor: AppColors.neutral300,
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
                    color: AppColors.neutral800, fontSize: FontSize.s12),
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
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: Color(0xFFF5F5F5))),
        ),
        child: AppButton(
          text: AppStrings.submitRating,
          onPressed: _selectedStars > 0 ? _onSubmit : () {},
          backgroundColor:
              _selectedStars > 0 ? AppColors.primary : AppColors.neutral600,
        ),
      );
}
