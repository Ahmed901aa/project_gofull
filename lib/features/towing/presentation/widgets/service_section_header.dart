import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';

class ServiceSectionHeader extends StatelessWidget {
  final String title;
  final double gap;

  const ServiceSectionHeader({super.key, required this.title, required this.gap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(height: gap),
      ],
    );
  }
}
