import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/service_input_field.dart';
import 'photo_picker_section.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class TowingCarDetailsForm extends StatefulWidget {
  final TextEditingController carTypeCtrl;
  final TextEditingController plateCtrl;

  /// Whether to surface inline validation errors. The parent should set this
  /// to `true` once the user attempts to submit, so empty fields highlight
  /// without showing red the moment the screen opens.
  final bool showValidation;

  const TowingCarDetailsForm({
    super.key,
    required this.carTypeCtrl,
    required this.plateCtrl,
    this.showValidation = false,
  });

  @override
  State<TowingCarDetailsForm> createState() => _TowingCarDetailsFormState();
}

class _TowingCarDetailsFormState extends State<TowingCarDetailsForm> {
  @override
  void initState() {
    super.initState();
    widget.carTypeCtrl.addListener(_onChange);
    widget.plateCtrl.addListener(_onChange);
  }

  void _onChange() => setState(() {});

  @override
  void dispose() {
    widget.carTypeCtrl.removeListener(_onChange);
    widget.plateCtrl.removeListener(_onChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final carTypeError = widget.showValidation &&
            widget.carTypeCtrl.text.trim().isEmpty
        ? l10n.pleaseEnterCarType
        : null;
    final plateError = widget.showValidation &&
            widget.plateCtrl.text.trim().isEmpty
        ? l10n.pleaseEnterPlateNumber
        : null;

    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: Insets.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ServiceInputField(
            label: l10n.vehicleTypeFieldLabel,
            helper: l10n.vehicleTypeFieldHelper,
            hint: l10n.vehicleTypeFieldHint,
            prefixIcon: Icons.directions_car_rounded,
            controller: widget.carTypeCtrl,
            textInputAction: TextInputAction.next,
            errorText: carTypeError,
          ),
          SizedBox(height: Sizes.s16),
          ServiceInputField(
            label: l10n.plateNumberFieldLabel,
            helper: l10n.plateNumberFieldHelper,
            hint: l10n.plateNumberFieldHint,
            prefixIcon: Icons.credit_card_rounded,
            controller: widget.plateCtrl,
            textInputAction: TextInputAction.done,
            errorText: plateError,
          ),
          SizedBox(height: Sizes.s20),
          Text(
            l10n.vehiclePhotosLabel,
            style: getSemiBoldStyle(
              color: context.colors.textPrimary,
              fontSize: FontSize.s14,
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 2.h),
          Text(
            l10n.vehiclePhotosHelper,
            style: getRegularStyle(
              color: context.colors.textSecondary,
              fontSize: FontSize.s12,
            ),
          ),
          SizedBox(height: 6.h),
          const PhotoPickerSection(),
        ],
      ),
    );
  }
}
