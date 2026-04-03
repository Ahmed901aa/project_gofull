import 'package:project_gofull/features/orders/models/order_data.dart';

/// Creates an updated [OrderData] with isRated=true if locally rated.
OrderData buildEffectiveOrder(OrderData order, bool isLocallyRated) {
  if (isLocallyRated && !order.isRated) {
    return OrderData(
      id: order.id,
      serviceType: order.serviceType,
      status: order.status,
      price: order.price,
      carType: order.carType,
      plateNumber: order.plateNumber,
      isRated: true,
      fromAddress: order.fromAddress,
      toAddress: order.toAddress,
      winchType: order.winchType,
      location: order.location,
      fuelType: order.fuelType,
      quantity: order.quantity,
    );
  }
  return order;
}
