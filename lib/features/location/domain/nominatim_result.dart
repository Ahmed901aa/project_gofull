class NominatimResult {
  final String displayName;
  final double lat;
  final double lng;

  const NominatimResult({
    required this.displayName,
    required this.lat,
    required this.lng,
  });

  String get title => displayName.split(',').first.trim();
  String get subtitle => displayName.split(',').skip(1).join(',').trim();
}
