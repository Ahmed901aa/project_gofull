import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/color_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';
import 'map_suggestion.dart';

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildInputRow(),
        const Divider(color: AppColors.divider, height: 1),
        _buildResults(),
      ],
    );
  }

  Widget _buildInputRow() {
    return Container(
      color: AppColors.white,
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
              decoration: const BoxDecoration(
                  color: AppColors.lightGrey,
                  shape: BoxShape.circle),
              child: Icon(Icons.arrow_back,
                  size: 18.sp, color: AppColors.black),
            ),
          ),
          SizedBox(width: Insets.s8),
          Expanded(
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(AppRadius.s12),
              ),
              padding: EdgeInsets.symmetric(horizontal: Insets.s12),
              child: Row(
                children: [
                  Icon(Icons.search_rounded,
                      color: AppColors.grey, size: 18.sp),
                  SizedBox(width: Insets.s8),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      autofocus: true,
                      textDirection: TextDirection.rtl,
                      textInputAction: TextInputAction.search,
                      style: getMediumStyle(
                          color: AppColors.black,
                          fontSize: FontSize.s14),
                      decoration: InputDecoration(
                        hintText: 'ابحث عن مدينة أو منطقة...',
                        hintStyle: getRegularStyle(
                            color: AppColors.grey,
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
                          color: AppColors.grey, size: 16.sp),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (isLoading) {
      return Container(
        color: AppColors.white,
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: const Center(
          child: CircularProgressIndicator(
              color: AppColors.primary, strokeWidth: 2),
        ),
      );
    }
    if (suggestions.isEmpty) return const SizedBox.shrink();
    return Container(
      color: AppColors.white,
      constraints: BoxConstraints(maxHeight: 300.h),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: suggestions.length,
        separatorBuilder: (_, __) =>
            const Divider(color: AppColors.divider, height: 1),
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
                      color: AppColors.primary, size: 20.sp),
                  SizedBox(width: Insets.s12),
                  Expanded(
                    child: Text(
                      s.description,
                      style: getMediumStyle(
                          color: AppColors.black,
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
