import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class ServiceHeader extends StatelessWidget {
  final String title;
  const ServiceHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.surface,
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_rounded, size: 22.sp, color: context.colors.textPrimary),
                ),
                Text(title, style: getBoldStyle(color: context.colors.textPrimary, fontSize: FontSize.s20)),
                const SizedBox(width: 24),
              ],
            ),
          ),
          Divider(height: 1, color: context.colors.borderSubtle),
        ],
      ),
    );
  }
}
