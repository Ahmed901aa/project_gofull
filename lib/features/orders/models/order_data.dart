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

  // replace with API data later
  static const List<OrderData> mockOrders = [
    // [0] Current active tow — no rating button (trip ongoing)
    OrderData(
      id: 'order_0',
      serviceType: ServiceType.tow,
      status: OrderStatus.active,
      price: '985.00 ج.م',
      fromAddress: 'المنصورة، مدينة مبارك، شارع مكة',
      toAddress: 'الرياض، حي النزهة، شارع الأمير',
      winchType: 'ونش هيدروليك',
      carType: 'نيسان صني',
      plateNumber: 'أ ب م - 3541',
    ),
    // [1] Past cancelled tow — no rating button (cancelled)
    OrderData(
      id: 'order_1',
      serviceType: ServiceType.tow,
      status: OrderStatus.cancelled,
      price: '650.00 ج.م',
      fromAddress: 'القاهرة، مدينة نصر، شارع عباس العقاد',
      toAddress: 'الجيزة، حي الدقي، شارع النيل',
      winchType: 'ونش شبه مسطح',
      carType: 'تويوتا كورولا',
      plateNumber: 'س ط ر - 7812',
    ),
    // [2] Past completed fuel, not yet rated — shows rating button
    OrderData(
      id: 'order_2',
      serviceType: ServiceType.fuel,
      status: OrderStatus.completed,
      isRated: false,
      price: '320.00 ج.م',
      location: 'المنصورة، مدينة مبارك، شارع مكة',
      fuelType: 'بنزين 95',
      quantity: '30 لتر',
      carType: 'هيونداي اكسنت',
      plateNumber: 'م ن ص - 1234',
    ),
    // [3] Past completed tow, already rated — no rating button
    OrderData(
      id: 'order_3',
      serviceType: ServiceType.tow,
      status: OrderStatus.completed,
      isRated: true,
      price: '750.00 ج.م',
      fromAddress: 'الإسكندرية، سيدي جابر، شارع الجمهورية',
      toAddress: 'القاهرة، مصر الجديدة، شارع الثورة',
      winchType: 'ونش هيدروليك',
      carType: 'كيا سيراتو',
      plateNumber: 'ر س م - 9900',
    ),
  ];
}
