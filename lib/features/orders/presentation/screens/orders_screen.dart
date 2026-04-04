// replace with API data later
import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/features/orders/models/order_data.dart';
import 'package:project_gofull/features/orders/presentation/widgets/effective_order_builder.dart';
import 'package:project_gofull/features/orders/presentation/widgets/order_card.dart';
import 'package:project_gofull/features/orders/services/rating_service.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  static const _baseOrders = OrderData.mockOrders;
  final Map<String, bool> _ratedStatus = {};

  @override
  void initState() {
    super.initState();
    _loadRatedStatus();
  }

  Future<void> _loadRatedStatus() async {
    for (final order in _baseOrders) {
      _ratedStatus[order.id] = await RatingService.isOrderRated(order.id);
    }
    if (mounted) setState(() {});
  }

  Future<void> _navigateAndRefresh(String route, OrderData order) async {
    await Navigator.pushNamed(context, route,
        arguments: TripDetailsArgs(orderId: order.id, status: order.status, isRated: true));
    _loadRatedStatus();
  }

  Widget _buildOrderCard(OrderData order, String route) {
    final effective = buildEffectiveOrder(order, order.isRated || (_ratedStatus[order.id] ?? false));
    return OrderCard(order: effective, onTap: () => _navigateAndRefresh(route, order));
  }

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
                  _buildOrderCard(_baseOrders[0], Routes.towingTripDetails),
                  SizedBox(height: Sizes.s24),
                  _sectionTitle('الطلبات السابقة'),
                  SizedBox(height: Sizes.s8),
                  _buildOrderCard(_baseOrders[1], Routes.towingTripDetails),
                  SizedBox(height: Insets.s16),
                  _buildOrderCard(_baseOrders[2], Routes.tripDetails),
                  SizedBox(height: Insets.s16),
                  _buildOrderCard(_baseOrders[3], Routes.towingTripDetails),
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
        title, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18), textAlign: TextAlign.right);

  Widget _buildHeader(BuildContext context) => Container(
        color: AppColors.white,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Padding(
              padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
              child: Center(child: Text('طلباتي', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20))),
            ),
            const Divider(height: 1, color: Color(0xFFF5F5F5)),
          ],
        ),
      );
}
