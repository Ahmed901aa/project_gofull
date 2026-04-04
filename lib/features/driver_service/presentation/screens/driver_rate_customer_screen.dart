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
import 'package:project_gofull/core/widgets/service_header.dart';

class DriverRateCustomerScreen extends StatefulWidget {
  final DriverRateArgs args;
  const DriverRateCustomerScreen({super.key, required this.args});

  @override
  State<DriverRateCustomerScreen> createState() =>
      _DriverRateCustomerScreenState();
}

class _DriverRateCustomerScreenState extends State<DriverRateCustomerScreen> {
  int _selectedRating = 5;
  final TextEditingController _notesController = TextEditingController();
  static const int _maxChars = 80;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          const ServiceHeader(title: AppStrings.rateTrip),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(Insets.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildRatingBanner(),
                  SizedBox(height: Sizes.s24),
                  _buildStarRating(),
                  SizedBox(height: Sizes.s32),
                  _buildNotesSection(),
                  SizedBox(height: Sizes.s48),
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildRatingBanner() {
    return Container(
      padding: EdgeInsets.all(Insets.s20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.s16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.star_rounded,
            size: 40.sp,
            color: AppColors.gold,
          ),
          SizedBox(height: Insets.s12),
          Text(
            AppStrings.howWasCustomer,
            style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Insets.s8),
          Text(
            AppStrings.ratingHelps,
            style: getRegularStyle(
              color: AppColors.white.withValues(alpha: 0.8),
              fontSize: FontSize.s14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Insets.s20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.s12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          final starIndex = index + 1;
          final isSelected = starIndex <= _selectedRating;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedRating = starIndex;
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.s4),
              child: Icon(
                isSelected ? Icons.star_rounded : Icons.star_border_rounded,
                size: 44.sp,
                color: isSelected ? AppColors.gold : AppColors.grey,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.additionalNotes,
          style: getBoldStyle(color: AppColors.black, fontSize: FontSize.s16),
        ),
        SizedBox(height: Insets.s8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.s12),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              TextField(
                controller: _notesController,
                maxLength: _maxChars,
                maxLines: 4,
                textDirection: TextDirection.rtl,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: AppStrings.additionalNotesHint,
                  hintStyle: getRegularStyle(
                    color: AppColors.grey,
                    fontSize: FontSize.s14,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(Insets.s16),
                  counterText: '',
                ),
                style: getRegularStyle(
                  color: AppColors.black,
                  fontSize: FontSize.s14,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  Insets.s16,
                  0,
                  Insets.s16,
                  Insets.s8,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${_notesController.text.length}/$_maxChars',
                    style: getRegularStyle(
                      color: AppColors.grey,
                      fontSize: FontSize.s12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s24),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: AppButton(
        text: AppStrings.submitRating,
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
}
