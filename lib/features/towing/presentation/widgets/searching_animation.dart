import 'package:flutter/material.dart';
import 'package:project_gofull/core/widgets/loading_circle_widget.dart';

class SearchingAnimation extends StatelessWidget {
  const SearchingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoadingCircleWidget(
      icon: Icon(Icons.local_gas_station, color: Colors.white, size: 40),
    );
  }
}
