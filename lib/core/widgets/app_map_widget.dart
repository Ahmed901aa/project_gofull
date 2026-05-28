import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../config/api_keys.dart';
import '../resources/color_manager.dart';
import '../resources/values_manager.dart';
import 'app_map/map_suggestion.dart';
import 'app_map/map_search_bar.dart';
import 'app_map/map_search_overlay.dart';
import 'app_map/map_my_location_button.dart';
import 'app_map/map_confirm_button.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

/// Default fallback: Benghazi, Libya
const _kDefaultLat = 32.1194;
const _kDefaultLng = 20.0868;

/// Reusable full-screen Google Map widget.
class AppMapWidget extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;
  final void Function(LatLng location, String address)? onLocationSelected;
  final bool showConfirmButton;
  final String? confirmLabel;

  const AppMapWidget({
    super.key,
    this.initialLat,
    this.initialLng,
    this.onLocationSelected,
    this.showConfirmButton = true,
    this.confirmLabel,
  });

  @override
  State<AppMapWidget> createState() => _AppMapWidgetState();
}

class _AppMapWidgetState extends State<AppMapWidget> {
  static const _apiKey = ApiKeys.googleMaps;

  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  LatLng? _pickedLocation;
  String _pickedAddress = '';

  // GPS resolution
  bool _resolvingGps = true;
  late LatLng _initialPosition;

  bool _isSearching = false;
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  List<MapSuggestion> _suggestions = [];
  bool _loadingSuggestions = false;
  Timer? _debounce;
  final _dio = Dio();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _resolveInitialLocation();
  }

  /// Resolve the initial map position:
  /// 1. Use explicit initialLat/initialLng if provided
  /// 2. Get live GPS position
  /// 3. Fall back to Benghazi defaults
  Future<void> _resolveInitialLocation() async {
    // If explicit coordinates were passed, use them directly
    if (widget.initialLat != null && widget.initialLng != null) {
      setState(() {
        _initialPosition = LatLng(widget.initialLat!, widget.initialLng!);
        _resolvingGps = false;
      });
      return;
    }

    // Try GPS
    try {
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        _useDefault();
        return;
      }

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _useDefault();
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      if (mounted) {
        setState(() {
          _initialPosition = LatLng(pos.latitude, pos.longitude);
          _resolvingGps = false;
        });
      }
    } catch (_) {
      _useDefault();
    }
  }

  void _useDefault() {
    if (mounted) {
      setState(() {
        _initialPosition = const LatLng(_kDefaultLat, _kDefaultLng);
        _resolvingGps = false;
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocus.dispose();
    _mapController?.dispose();
    _dio.close();
    super.dispose();
  }

  Future<void> _moveToGps() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) return;
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      if (!mounted) return;
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
            LatLng(pos.latitude, pos.longitude), 15),
      );
    } catch (_) {}
  }

  void _onSearchChanged() {
    final q = _searchController.text.trim();
    if (q.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 450),
      () => _fetchSuggestions(q),
    );
  }

  Future<void> _fetchSuggestions(String query) async {
    setState(() => _loadingSuggestions = true);
    try {
      final res = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json',
        queryParameters: {
          'input': query,
          'key': _apiKey,
          'language': Localizations.localeOf(context).languageCode,
        },
      );
      final status = res.data['status'] as String;
      final list = status == 'OK' ? res.data['predictions'] as List : [];
      if (!mounted) return;
      setState(() {
        _suggestions = list
            .map((p) => MapSuggestion(
                  description: p['description'] as String,
                  placeId: p['place_id'] as String,
                ))
            .toList();
        _loadingSuggestions = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loadingSuggestions = false);
    }
  }

  Future<void> _selectSuggestion(MapSuggestion s) async {
    _searchFocus.unfocus();
    setState(() {
      _isSearching = false;
      _suggestions = [];
      _searchController.text = s.description;
      _loadingSuggestions = false;
    });
    try {
      final res = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/details/json',
        queryParameters: {
          'place_id': s.placeId,
          'fields': 'geometry',
          'key': _apiKey,
        },
      );
      if (res.data['status'] != 'OK') return;
      final loc = res.data['result']['geometry']['location'];
      final latLng = LatLng(
        (loc['lat'] as num).toDouble(),
        (loc['lng'] as num).toDouble(),
      );
      _placeMarker(latLng, s.description);
    } catch (_) {}
  }

  void _placeMarker(LatLng latLng, String address) {
    setState(() {
      _pickedLocation = latLng;
      _pickedAddress = address;
      _markers = {
        Marker(
          markerId: const MarkerId('picked'),
          position: latLng,
          infoWindow: InfoWindow(title: address),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
      };
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(latLng, 15),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while resolving GPS
    if (_resolvingGps) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return Directionality(
      textDirection: Directionality.of(context),
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 15,
            ),
            onMapCreated: (c) => _mapController = c,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            markers: _markers,
            onTap: (latLng) => _placeMarker(latLng, ''),
          ),
          SafeArea(
            child: Material(
              type: MaterialType.transparency,
              child: _isSearching
                  ? MapSearchOverlay(
                      controller: _searchController,
                      focusNode: _searchFocus,
                      suggestions: _suggestions,
                      isLoading: _loadingSuggestions,
                      onBack: () {
                        setState(() {
                          _isSearching = false;
                          _suggestions = [];
                        });
                        _searchFocus.unfocus();
                      },
                      onClear: () {
                        _searchController.clear();
                        setState(() => _suggestions = []);
                      },
                      onSuggestionTap: _selectSuggestion,
                      onSubmit: () {
                        if (_suggestions.isNotEmpty) {
                          _selectSuggestion(_suggestions.first);
                        }
                      },
                    )
                  : MapSearchBar(
                      text: _searchController.text,
                      onTap: () {
                        setState(() => _isSearching = true);
                        Future.microtask(
                            () => _searchFocus.requestFocus());
                      },
                      onClear: () {
                        _searchController.clear();
                        setState(() {
                          _markers = {};
                          _pickedLocation = null;
                          _pickedAddress = '';
                        });
                      },
                    ),
            ),
          ),
          Positioned(
            left: Insets.s16,
            bottom: widget.showConfirmButton && _pickedLocation != null
                ? 124.h
                : 24.h,
            child: MapMyLocationButton(onTap: _moveToGps),
          ),
          if (widget.showConfirmButton && _pickedLocation != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: MapConfirmButton(
                address: _pickedAddress,
                label: widget.confirmLabel ?? S.of(context).confirmLocation,
                onTap: () => widget.onLocationSelected
                    ?.call(_pickedLocation!, _pickedAddress),
              ),
            ),
        ],
      ),
    );
  }
}
