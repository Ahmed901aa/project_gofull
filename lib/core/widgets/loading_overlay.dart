import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: context.colors.textPrimary.withValues(alpha: 0.3),
            child: Center(
              child: CircularProgressIndicator(
                color: context.colors.primary,
              ),
            ),
          ),
      ],
    );
  }
}
