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

class OtpArgs {
  final String phone;
  const OtpArgs({required this.phone});
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
  const SearchingArgs({
    required this.searchingText,
    required this.subtitleText,
    required this.nextRoute,
    this.nextRouteArgs,
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
