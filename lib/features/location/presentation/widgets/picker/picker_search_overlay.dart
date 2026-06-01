import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import '../../../domain/nominatim_result.dart';
import 'picker_suggestion_tile.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/widgets/directional_icon.dart';

class PickerSearchOverlay extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<NominatimResult> suggestions;
  final bool isLoading;
  final VoidCallback onBack;
  final VoidCallback onClear;
  final ValueChanged<NominatimResult> onSelect;

  const PickerSearchOverlay({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.suggestions,
    required this.isLoading,
    required this.onBack,
    required this.onClear,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: context.colors.surface,
          padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
          child: Row(children: [
            GestureDetector(
              onTap: onBack,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 36.w, height: 36.w,
                decoration: BoxDecoration(color: context.colors.surfaceVariant, shape: BoxShape.circle),
                child: Icon(backArrowIcon(context), size: 18.sp, color: context.colors.textPrimary),
              ),
            ),
            SizedBox(width: Insets.s8),
            Expanded(child: Container(
              height: 44.h,
              padding: EdgeInsets.symmetric(horizontal: Insets.s12),
              decoration: BoxDecoration(color: context.colors.surfaceVariant, borderRadius: BorderRadius.circular(AppRadius.s12)),
              child: Row(children: [
                Icon(Icons.search_rounded, color: context.colors.iconSecondary, size: 18.sp),
                SizedBox(width: Insets.s8),
                Expanded(child: TextField(
                  controller: controller, focusNode: focusNode, autofocus: true, textInputAction: TextInputAction.search,
                  style: getMediumStyle(color: context.colors.textPrimary, fontSize: FontSize.s14),
                  decoration: InputDecoration(
                    hintText: S.of(context).searchForCityOrDistrict, border: InputBorder.none, isDense: true,
                    hintStyle: getRegularStyle(color: context.colors.iconSecondary, fontSize: FontSize.s14),
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  onSubmitted: (_) { if (suggestions.isNotEmpty) onSelect(suggestions.first); },
                )),
                if (controller.text.isNotEmpty)
                  GestureDetector(onTap: onClear, behavior: HitTestBehavior.opaque,
                    child: Icon(Icons.close, color: context.colors.iconSecondary, size: 16.sp)),
              ]),
            )),
          ]),
        ),
        Divider(color: context.colors.divider, height: 1),
        if (isLoading)
          Container(color: context.colors.surface, padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Center(child: CircularProgressIndicator(color: context.colors.primary, strokeWidth: 2)))
        else if (suggestions.isNotEmpty)
          Container(
            color: context.colors.surface,
            constraints: BoxConstraints(maxHeight: 300.h),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: suggestions.length,
              separatorBuilder: (_, __) => Divider(color: context.colors.divider, height: 1),
              itemBuilder: (_, i) => PickerSuggestionTile(item: suggestions[i], onTap: onSelect),
            ),
          ),
      ],
    );
  }
}
