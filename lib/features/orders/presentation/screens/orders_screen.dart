// replace with API data later
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/features/orders/models/order_data.dart';
import 'package:project_gofull/features/orders/presentation/widgets/order_card.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  // replace with API data later
  static const _orders = OrderData.mockOrders;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(Insets.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: Sizes.s8),
                  _sectionTitle('الطلب الحالي'),
                  SizedBox(height: Sizes.s8),
                  OrderCard(
                    order: _orders[0],
                    onTap: () => Navigator.pushNamed(context, Routes.towingTripDetails),
                  ),
                  SizedBox(height: Sizes.s24),
                  _sectionTitle('الطلبات السابقة'),
                  SizedBox(height: Sizes.s8),
                  OrderCard(
                    order: _orders[1],
                    onTap: () => Navigator.pushNamed(context, Routes.towingTripDetails),
                  ),
                  SizedBox(height: Insets.s16),
                  OrderCard(
                    order: _orders[2],
                    onTap: () => Navigator.pushNamed(context, Routes.tripDetails),
                  ),
                  SizedBox(height: Sizes.s16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(
        title,
        style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
        textAlign: TextAlign.right,
      );

  Widget _buildHeader(BuildContext context) => Container(
        color: AppColors.white,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Padding(
              padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.close_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
                  ),
                  Text(
                    'طلباتي',
                    style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.close_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF5F5F5)),
          ],
        ),
      );
}
