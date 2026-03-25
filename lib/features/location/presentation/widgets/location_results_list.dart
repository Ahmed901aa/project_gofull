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

/// Results list matching Figma: place info on RIGHT, arrow icon on LEFT.
/// RTL Row: first child = rightmost, last child = leftmost.
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // RTL first child → rightmost = place info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(item.title,
                      style: getBoldStyle(
                          color: const Color(0xFF0E0E0E),
                          fontSize: FontSize.s14)),
                  if (item.subtitle.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(item.subtitle,
                        style: getRegularStyle(
                            color: AppColors.neutral900,
                            fontSize: FontSize.s12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.rtl),
                  ],
                ],
              ),
            ),
            SizedBox(width: Insets.s12),
            // RTL last child → leftmost = arrow icon
            Icon(Icons.north_west_rounded,
                color: const Color(0xFF646565), size: 20.sp),
          ],
        ),
      ),
    );
  }
}
