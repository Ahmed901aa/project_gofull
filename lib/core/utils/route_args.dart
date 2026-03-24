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
  const DriverFoundArgs({
    required this.title,
    required this.vehicleLabel,
    required this.vehicleValue,
    this.showClose = false,
    this.imagePath,
    this.nextRoute,
  });
}

class TowingStartedArgs {
  final String title;
  final String subtitle;
  final String imagePath;
  final String vehicleLabel;
  final String vehicleValue;
  const TowingStartedArgs({
    this.title = 'السائق وصل لموقعك.',
    this.subtitle = 'يتم الآن تحميل وتأمين السيارة على الونش لبدء الرحلة إلى وجهتك.',
    this.imagePath = 'assets/images/service_tools.gif',
    this.vehicleLabel = 'نوع الونش',
    this.vehicleValue = 'ونش هيدروليك',
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
