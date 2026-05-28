import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class ArrivedCarPhotos extends StatelessWidget {
  const ArrivedCarPhotos({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(S.of(context).carPhotos, style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s18), textAlign: TextAlign.start),
        SizedBox(height: Insets.s8),
        Row(
          children: List.generate(
            3,
            (i) => Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.only(end: i < 2 ? Insets.s8 : 0),
                child: const _PhotoPlaceholder(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88.h,
      decoration: BoxDecoration(
        color: context.colors.inputFill,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: context.colors.border),
      ),
      child: Icon(Icons.image_outlined, size: 28.sp, color: context.colors.border),
    );
  }
}
