class LocationState {
  final String address;
  final double? lat;
  final double? lng;

  const LocationState({
    this.address = '',
    this.lat,
    this.lng,
  });

  LocationState copyWith({String? address, double? lat, double? lng}) =>
      LocationState(
        address: address ?? this.address,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
      );
}
