import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

import '../../resources/font_manager.dart';
import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';
import 'map_suggestion.dart';
import 'package:project_gofull/core/resources/app_theme.dart';
import 'package:project_gofull/core/widgets/directional_icon.dart';

class MapSearchOverlay extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<MapSuggestion> suggestions;
  final bool isLoading;
  final VoidCallback onBack;
  final VoidCallback onClear;
  final ValueChanged<MapSuggestion> onSuggestionTap;
  final VoidCallback onSubmit;

  const MapSearchOverlay({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.suggestions,
    required this.isLoading,
    required this.onBack,
    required this.onClear,
    required this.onSuggestionTap,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildInputRow(context, l10n),
        Divider(color: context.colors.divider, height: 1),
        _buildResults(context),
      ],
    );
  }

  Widget _buildInputRow(BuildContext context, S l10n) {
    return Container(
      color: context.colors.surface,
      padding: EdgeInsets.fromLTRB(
          Insets.s16, Insets.s12, Insets.s16, Insets.s12),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                  color: context.colors.surfaceVariant,
                  shape: BoxShape.circle),
              child: Icon(backArrowIcon(context),
                  size: 18.sp, color: context.colors.textPrimary),
            ),
          ),
          SizedBox(width: Insets.s8),
          Expanded(
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: context.colors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.s12),
              ),
              padding: EdgeInsets.symmetric(horizontal: Insets.s12),
              child: Row(
                children: [
                  Icon(Icons.search_rounded,
                      color: context.colors.iconSecondary, size: 18.sp),
                  SizedBox(width: Insets.s8),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      style: getMediumStyle(
                          color: context.colors.textPrimary,
                          fontSize: FontSize.s14),
                      decoration: InputDecoration(
                        hintText: l10n.searchCityOrArea,
                        hintStyle: getRegularStyle(
                            color: context.colors.iconSecondary,
                            fontSize: FontSize.s14),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      onSubmitted: (_) => onSubmit(),
                    ),
                  ),
                  if (controller.text.isNotEmpty)
                    GestureDetector(
                      onTap: onClear,
                      behavior: HitTestBehavior.opaque,
                      child: Icon(Icons.close,
                          color: context.colors.iconSecondary, size: 16.sp),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(BuildContext context) {
    if (isLoading) {
      return Container(
        color: context.colors.surface,
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Center(
          child: CircularProgressIndicator(
              color: context.colors.primary, strokeWidth: 2),
        ),
      );
    }
    if (suggestions.isEmpty) {

      return const SizedBox.shrink();

    }
    return Container(
      color: context.colors.surface,
      constraints: BoxConstraints(maxHeight: 300.h),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: suggestions.length,
        separatorBuilder: (_, __) =>
            Divider(color: context.colors.divider, height: 1),
        itemBuilder: (_, i) {
          final s = suggestions[i];
          return InkWell(
            onTap: () => onSuggestionTap(s),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Insets.s16, vertical: Insets.s12),
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      color: context.colors.primary, size: 20.sp),
                  SizedBox(width: Insets.s12),
                  Expanded(
                    child: Text(
                      s.description,
                      style: getMediumStyle(
                          color: context.colors.textPrimary,
                          fontSize: FontSize.s14),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
