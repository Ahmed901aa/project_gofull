// replace with API data later

enum ServiceType { tow, fuel }

enum OrderStatus { active, cancelled, completed }

class OrderData {
  final ServiceType serviceType;
  final OrderStatus status;
  final String price;

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
    required this.serviceType,
    required this.status,
    required this.price,
    required this.carType,
    required this.plateNumber,
    this.fromAddress,
    this.toAddress,
    this.winchType,
    this.location,
    this.fuelType,
    this.quantity,
  });

  // replace with API data later
  static const List<OrderData> mockOrders = [
    // Current active tow order
    OrderData(
      serviceType: ServiceType.tow,
      status: OrderStatus.active,
      price: '985.00 ج.م',
      fromAddress: 'المنصورة، مدينة مبارك، شارع مكة',
      toAddress: 'الرياض، حي النزهة، شارع الأمير',
      winchType: 'ونش هيدروليك',
      carType: 'نيسان صني',
      plateNumber: 'أ ب م - 3541',
    ),
    // Past cancelled tow order
    OrderData(
      serviceType: ServiceType.tow,
      status: OrderStatus.cancelled,
      price: '650.00 ج.م',
      fromAddress: 'القاهرة، مدينة نصر، شارع عباس العقاد',
      toAddress: 'الجيزة، حي الدقي، شارع النيل',
      winchType: 'ونش شبه مسطح',
      carType: 'تويوتا كورولا',
      plateNumber: 'س ط ر - 7812',
    ),
    // Past completed fuel order
    OrderData(
      serviceType: ServiceType.fuel,
      status: OrderStatus.completed,
      price: '320.00 ج.م',
      location: 'المنصورة، مدينة مبارك، شارع مكة',
      fuelType: 'بنزين 95',
      quantity: '30 لتر',
      carType: 'هيونداي اكسنت',
      plateNumber: 'م ن ص - 1234',
    ),
  ];
}
