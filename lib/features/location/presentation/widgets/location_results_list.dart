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
  const LocationItem({required this.title, required this.subtitle, this.placeId});
}

class LocationResultsList extends StatelessWidget {
  final List<LocationItem> items;
  final void Function(LocationItem)? onItemTap;

  const LocationResultsList({super.key, required this.items, this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(top: 4.h),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(color: AppColors.divider, height: 1),
      itemBuilder: (context, index) {
        final loc = items[index];
        return InkWell(
          onTap: () {
            if (onItemTap != null) {
              onItemTap!(loc);
            } else {
              Navigator.pop(context, loc.title);
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(loc.title, style: getMediumStyle(color: AppColors.black, fontSize: FontSize.s14)),
                      SizedBox(height: 4.h),
                      Text(
                        loc.subtitle,
                        style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: Insets.s12),
                Icon(Icons.north_west_rounded, color: AppColors.grey, size: 20.sp),
              ],
            ),
          ),
        );
      },
    );
  }
}
