import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import '../../../domain/nominatim_result.dart';

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
          color: AppColors.white,
          padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
          child: Row(children: [
            GestureDetector(
              onTap: onBack,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 36.w, height: 36.w,
                decoration: const BoxDecoration(color: AppColors.lightGrey, shape: BoxShape.circle),
                child: Icon(Icons.arrow_back, size: 18.sp, color: AppColors.black),
              ),
            ),
            SizedBox(width: Insets.s8),
            Expanded(child: Container(
              height: 44.h,
              padding: EdgeInsets.symmetric(horizontal: Insets.s12),
              decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(AppRadius.s12)),
              child: Row(children: [
                Icon(Icons.search_rounded, color: AppColors.grey, size: 18.sp),
                SizedBox(width: Insets.s8),
                Expanded(child: TextField(
                  controller: controller, focusNode: focusNode, autofocus: true,
                  textDirection: TextDirection.rtl, textInputAction: TextInputAction.search,
                  style: getMediumStyle(color: AppColors.black, fontSize: FontSize.s14),
                  decoration: InputDecoration(
                    hintText: 'ابحث عن مدينة أو حي...', border: InputBorder.none, isDense: true,
                    hintStyle: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s14),
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  onSubmitted: (_) { if (suggestions.isNotEmpty) onSelect(suggestions.first); },
                )),
                if (controller.text.isNotEmpty)
                  GestureDetector(onTap: onClear, behavior: HitTestBehavior.opaque,
                    child: Icon(Icons.close, color: AppColors.grey, size: 16.sp)),
              ]),
            )),
          ]),
        ),
        const Divider(color: AppColors.divider, height: 1),
        if (isLoading)
          Container(color: AppColors.white, padding: EdgeInsets.symmetric(vertical: 20.h),
            child: const Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)))
        else if (suggestions.isNotEmpty)
          Container(
            color: AppColors.white,
            constraints: BoxConstraints(maxHeight: 300.h),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: suggestions.length,
              separatorBuilder: (_, __) => const Divider(color: AppColors.divider, height: 1),
              itemBuilder: (_, i) => _SuggestionTile(item: suggestions[i], onTap: onSelect),
            ),
          ),
      ],
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  final NominatimResult item;
  final ValueChanged<NominatimResult> onTap;
  const _SuggestionTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(item),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
        child: Row(children: [
          Icon(Icons.location_on_outlined, color: AppColors.primary, size: 20.sp),
          SizedBox(width: Insets.s12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.title, style: getMediumStyle(color: AppColors.black, fontSize: FontSize.s14)),
            if (item.subtitle.isNotEmpty)
              Text(item.subtitle, style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s12),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
          ])),
        ]),
      ),
    );
  }
}
