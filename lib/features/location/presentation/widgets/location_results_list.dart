import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class LocationItem {
  final String title;
  final String subtitle;
  final String? placeId;
  const LocationItem(
      {required this.title, required this.subtitle, this.placeId});
}

class LocationResultsList extends StatelessWidget {
  final List<LocationItem> items;
  final void Function(LocationItem) onItemTap;
  const LocationResultsList(
      {super.key, required this.items, required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Text('لا توجد نتائج',
            style: getRegularStyle(
                color: AppColors.neutral800, fontSize: FontSize.s14)),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.only(top: 4.h),
      itemCount: items.length,
      separatorBuilder: (_, __) =>
          const Divider(color: AppColors.neutral500, height: 1),
      itemBuilder: (_, i) => _ResultTile(item: items[i], onTap: onItemTap),
    );
  }
}

/// Matches PickerSuggestionTile style:
/// RTL Row → location icon (right) | title + subtitle (expanded left)
class _ResultTile extends StatelessWidget {
  final LocationItem item;
  final void Function(LocationItem) onTap;
  const _ResultTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(item),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Insets.s16, vertical: Insets.s12),
        child: Row(
          children: [
            // RTL first child → rightmost = location pin icon
            Icon(Icons.location_on_outlined,
                color: AppColors.primary, size: 20.sp),
            SizedBox(width: Insets.s12),
            // Expanded text column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: getMediumStyle(
                          color: AppColors.black, fontSize: FontSize.s14)),
                  if (item.subtitle.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(item.subtitle,
                        style: getRegularStyle(
                            color: AppColors.grey, fontSize: FontSize.s12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
