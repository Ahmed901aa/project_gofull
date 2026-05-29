part of '../driver_navigate_screen.dart';

extension _NavigateLocation on _DriverNavigateScreenState {
  LatLng get _destination => LatLng(
        widget.args.lat ?? _defaultLat,
        widget.args.lng ?? _defaultLng,
      );

  bool get _isToCustomer => widget.args.navigationType == 'to_customer';

  void _rebuildMapObjects() {
    final objects = buildNavigateMapObjects(
      context,
      destination: _destination,
      providerPosition: _providerPosition,
      isToCustomer: _isToCustomer,
      address: widget.args.address,
    );
    _cachedMarkers = objects.markers;
    _cachedPolylines = objects.polylines;
  }

  /// Get initial position then start periodic updates.
  Future<void> _initLocation() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _startLocationUpdates();
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );
      if (mounted) {
        _providerPosition = LatLng(pos.latitude, pos.longitude);
        _rebuildMapObjects();
        setState(() {});
        _fitBounds();
      }
    } catch (_) {}
    _startLocationUpdates();
  }

  void _startLocationUpdates() {
    _sendCurrentLocation();
    _locationTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _sendCurrentLocation();
    });
  }

  Future<void> _sendCurrentLocation() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 5),
        ),
      );
      sl<ApiClient>().dio.patch('/provider/profile/location', data: {
        'latitude': pos.latitude,
        'longitude': pos.longitude,
      });
      if (!mounted) return;

      final providerLatLng = LatLng(pos.latitude, pos.longitude);
      final km = haversineKm(
          pos.latitude, pos.longitude, _destination.latitude, _destination.longitude);
      _providerPosition = providerLatLng;
      _remainingDistance = '${km.toStringAsFixed(1)} ${S.of(context).kmUnit}';
      _rebuildMapObjects();
      setState(() {});
      _mapController?.animateCamera(CameraUpdate.newLatLng(providerLatLng));
    } catch (_) {}
  }

  Future<void> _moveToCurrentLocation() async {
    if (_providerPosition != null) {
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(_providerPosition!, 15));
      return;
    }
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      if (!mounted) return;
      _mapController
          ?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(pos.latitude, pos.longitude), 15));
    } catch (_) {}
  }

  /// Fit camera to show both provider and destination markers.
  void _fitBounds() {
    if (_providerPosition == null || _mapController == null) return;
    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(boundsFor(_providerPosition!, _destination), 80),
    );
  }
}
