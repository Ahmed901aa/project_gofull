import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import '../../../domain/nominatim_result.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class PickerSuggestionTile extends StatelessWidget {
  final NominatimResult item;
  final ValueChanged<NominatimResult> onTap;

  const PickerSuggestionTile({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(item),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
        child: Row(children: [
          Icon(Icons.location_on_outlined, color: context.colors.primary, size: 20.sp),
          SizedBox(width: Insets.s12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.title,
                  style: getMediumStyle(color: context.colors.textPrimary, fontSize: FontSize.s14)),
              if (item.subtitle.isNotEmpty)
                Text(item.subtitle,
                    style: getRegularStyle(color: context.colors.iconSecondary, fontSize: FontSize.s12),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
            ]),
          ),
        ]),
      ),
    );
  }
}
