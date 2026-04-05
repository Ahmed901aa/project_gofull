import 'package:project_gofull/features/orders/models/order_data.dart';

class TripDetailsArgs {
  final String orderId;
  final OrderStatus status;
  final bool isRated;
  const TripDetailsArgs({required this.orderId, required this.status, this.isRated = false});
}

class RatingArgs {
  final String orderId;
  const RatingArgs({required this.orderId});
}

class LocationSearchArgs {
  final String title;
  final bool showCurrentLocation;
  const LocationSearchArgs({
    required this.title,
    this.showCurrentLocation = false,
  });
}

class MapSelectionArgs {
  final String title;
  final double? initialLat;
  final double? initialLng;
  const MapSelectionArgs({
    required this.title,
    this.initialLat,
    this.initialLng,
  });
}

class SearchingArgs {
  final String searchingText;
  final String subtitleText;
  final String nextRoute;
  final Object? nextRouteArgs;
  final int? requestId; // real backend request ID for polling
  final String serviceType; // 'fuel_delivery' or 'towing'
  const SearchingArgs({
    required this.searchingText,
    required this.subtitleText,
    required this.nextRoute,
    this.nextRouteArgs,
    this.requestId,
    this.serviceType = 'fuel_delivery',
  });
}

class DriverFoundArgs {
  final String title;
  final String vehicleLabel;
  final String vehicleValue;
  final bool showClose;
  final String? imagePath;
  final String? nextRoute; // optional auto-navigate when ETA reaches 0
  final Object? nextRouteArgs;
  const DriverFoundArgs({
    required this.title,
    required this.vehicleLabel,
    required this.vehicleValue,
    this.showClose = false,
    this.imagePath,
    this.nextRoute,
    this.nextRouteArgs,
  });
}

class TowingStartedArgs {
  final String title;
  final String subtitle;
  final String imagePath;
  final String vehicleLabel;
  final String vehicleValue;
  final Object? nextRouteArgs;
  const TowingStartedArgs({
    this.title = 'السائق وصل لموقعك.',
    this.subtitle = 'يتم الآن تحميل وتأمين السيارة على الونش لبدء الرحلة إلى وجهتك.',
    this.imagePath = 'assets/images/service_tools.gif',
    this.vehicleLabel = 'نوع الونش',
    this.vehicleValue = 'ونش هيدروليك',
    this.nextRouteArgs,
  });
}

class TripInProgressArgs {
  final String originAddress;
  final String destinationAddress;
  final double? originLat;
  final double? originLng;
  final double? destinationLat;
  final double? destinationLng;
  const TripInProgressArgs({
    required this.originAddress,
    required this.destinationAddress,
    this.originLat,
    this.originLng,
    this.destinationLat,
    this.destinationLng,
  });
}

class ServiceArrivedArgs {
  final String title;
  final String subtitle;
  final String imagePath;
  final String vehicleLabel;
  final String vehicleValue;
  const ServiceArrivedArgs({
    this.title = 'بدء عملية تعبئة الوقود',
    this.subtitle = 'مزود الخدمة متواجد الآن في موقعك وبانتظارك.',
    this.imagePath = 'assets/images/refuel.gif',
    this.vehicleLabel = 'نوع المركبة',
    this.vehicleValue = 'سيارة إمداد وقود',
  });
}

// ── Driver App Route Args ────────────────────────────────

class DriverOrderDetailsArgs {
  final String orderId;
  final String serviceType; // 'towing' or 'fuel'
  final String customerName;
  final String customerPhone;
  final String pickupAddress;
  final String deliveryAddress;
  final String carType;
  final String plateNumber;
  final double distance;
  final double amount;
  final String paymentMethod;
  final String? customerNotes;
  final List<String> carPhotos;
  // Fuel-specific
  final String? fuelType;
  final String? fuelQuantity;
  final String? pricePerLiter;

  const DriverOrderDetailsArgs({
    required this.orderId,
    required this.serviceType,
    required this.customerName,
    required this.customerPhone,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.carType,
    required this.plateNumber,
    required this.distance,
    required this.amount,
    this.paymentMethod = 'كاش',
    this.customerNotes,
    this.carPhotos = const [],
    this.fuelType,
    this.fuelQuantity,
    this.pricePerLiter,
  });
}

class DriverNavigateArgs {
  final String orderId;
  final String address;
  final double? lat;
  final double? lng;
  final String navigationType; // 'to_customer' or 'to_destination'

  const DriverNavigateArgs({
    required this.orderId,
    required this.address,
    this.lat,
    this.lng,
    required this.navigationType,
  });
}

class DriverDocumentationArgs {
  final String orderId;
  final String documentationType; // 'pickup' or 'delivery'

  const DriverDocumentationArgs({
    required this.orderId,
    required this.documentationType,
  });
}

class DriverCollectPaymentArgs {
  final String orderId;
  final double amount;
  final String paymentMethod;

  const DriverCollectPaymentArgs({
    required this.orderId,
    required this.amount,
    this.paymentMethod = 'كاش',
  });
}

class DriverTaskCompleteArgs {
  final String orderId;
  final double earnings;

  const DriverTaskCompleteArgs({
    required this.orderId,
    required this.earnings,
  });
}

class DriverRateArgs {
  final String orderId;

  const DriverRateArgs({
    required this.orderId,
  });
}

class DriverTripDetailsArgs {
  final String orderId;
  final String serviceType; // 'towing' or 'fuel'
  final bool isRated;

  const DriverTripDetailsArgs({
    required this.orderId,
    required this.serviceType,
    this.isRated = false,
  });
}
