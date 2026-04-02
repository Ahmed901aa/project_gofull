import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'order_address_column.dart';
import 'order_badges_row.dart';
import 'order_price_row.dart';
import 'order_route_connector.dart';

class ActiveOrderCard extends StatelessWidget {
  const ActiveOrderCard({super.key});

  static const String _fromAddress = 'المنصورة، مدينة مبارك، شارع مكة';
  static const String _toAddress = 'الرياض، حي النزهة، شارع الأمير';
  static const String _price = '985.00 ج.م';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: Sizes.s12),
            child: Text('طلبك الحالي', style: getSemiBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18), textAlign: TextAlign.right),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.neutral50,
              borderRadius: BorderRadius.circular(AppRadius.s16),
              border: Border.all(color: AppColors.neutral500),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const OrderBadgesRow(),
                _buildRouteCard(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Sizes.s12),
                  child: Divider(color: AppColors.neutral500, height: 1, thickness: 1),
                ),
                const OrderPriceRow(price: _price),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
      child: Container(
        padding: EdgeInsets.all(Insets.s12),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBg,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: AppColors.neutral500),
          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: const Offset(0, 1))],
        ),
        child: Row(
          children: [
            Expanded(child: OrderAddressColumn(label: 'نقطة الانطلاق', address: _fromAddress)),
            const OrderRouteConnector(),
            Expanded(child: OrderAddressColumn(label: 'نقطة الوصول', address: _toAddress)),
          ],
        ),
      ),
    );
  }
}
