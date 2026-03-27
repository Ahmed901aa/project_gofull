import 'package:flutter/material.dart';
import 'package:project_gofull/core/widgets/dotted_circle_container.dart';

class SearchingAnimation extends StatelessWidget {
  const SearchingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return const DottedCircleContainer(
      icon: Icon(Icons.local_gas_station, color: Colors.white, size: 40),
    );
  }
}
