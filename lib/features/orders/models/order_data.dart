// replace with API data later

enum ServiceType { tow, fuel }

enum OrderStatus { active, cancelled, completed }

class OrderData {
  final String id;
  final ServiceType serviceType;
  final OrderStatus status;
  final String price;
  final bool isRated; // replace with API data later — only meaningful for completed orders

  // tow-specific
  final String? fromAddress;
  final String? toAddress;
  final String? winchType;

  // fuel-specific
  final String? location;
  final String? fuelType;
  final String? quantity;

  // common
  final String carType;
  final String plateNumber;

  const OrderData({
    required this.id,
    required this.serviceType,
    required this.status,
    required this.price,
    required this.carType,
    required this.plateNumber,
    this.isRated = false,
    this.fromAddress,
    this.toAddress,
    this.winchType,
    this.location,
    this.fuelType,
    this.quantity,
  });

}
