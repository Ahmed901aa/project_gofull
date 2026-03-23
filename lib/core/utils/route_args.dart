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
  const SearchingArgs({
    required this.searchingText,
    required this.subtitleText,
    required this.nextRoute,
  });
}
