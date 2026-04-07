import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/dotted_circle_container.dart';
import 'driver_details_card.dart';

class DriverFoundBody extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String driverName;
  final String driverRating;
  final String driverReviewCount;
  final String driverPlateNumber;
  final String vehicleLabel;
  final String vehicleValue;

  const DriverFoundBody({
    super.key,
    required this.imagePath,
    required this.title,
    this.subtitle = 'وافق السائق على طلبك وهو الآن في طريقه إليك.',
    required this.driverName,
    required this.driverRating,
    required this.driverReviewCount,
    required this.driverPlateNumber,
    required this.vehicleLabel,
    required this.vehicleValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.scaffoldBg,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.s16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DottedCircleContainer(imagePath: imagePath),
              SizedBox(height: Insets.s16),
              Text(title, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18), textAlign: TextAlign.center),
              SizedBox(height: 4.h),
              Text(subtitle, style: getRegularStyle(color: AppColors.neutral800, fontSize: FontSize.s14), textAlign: TextAlign.center),
              SizedBox(height: Insets.s16),
              DriverDetailsCard(
                name: driverName,
                rating: driverRating,
                reviewCount: driverReviewCount,
                plateNumber: driverPlateNumber,
                vehicleLabel: vehicleLabel,
                vehicleValue: vehicleValue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
