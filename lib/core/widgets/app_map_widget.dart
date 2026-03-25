import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/styles_manager.dart';
import '../resources/values_manager.dart';

/// Reusable full-screen Google Map widget.
///
/// Usage:
///   AppMapWidget(
///     onLocationSelected: (latLng, address) { ... },
///   )
class AppMapWidget extends StatefulWidget {
  /// Initial map center. Defaults to Riyadh if null and GPS unavailable.
  final double? initialLat;
  final double? initialLng;

  /// Called when the user taps the confirm button.
  final void Function(LatLng location, String address)? onLocationSelected;

  /// Whether to show the bottom confirm button.
  final bool showConfirmButton;

  /// Label for the confirm button.
  final String confirmLabel;

  const AppMapWidget({
    super.key,
    this.initialLat,
    this.initialLng,
    this.onLocationSelected,
    this.showConfirmButton = true,
    this.confirmLabel = 'تأكيد الموقع',
  });

  @override
  State<AppMapWidget> createState() => _AppMapWidgetState();
}

class _AppMapWidgetState extends State<AppMapWidget> {
  static const _apiKey = 'AIzaSyDZ_ZezX058d36aMTOc9E--MbyWqCdOI9I';

  // Default to Riyadh when GPS is unavailable
  static const _defaultLat = 24.7136;
  static const _defaultLng = 46.6753;

  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  LatLng? _pickedLocation;
  String _pickedAddress = '';

  // Search state
  bool _isSearching = false;
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  List<_Suggestion> _suggestions = [];
  bool _loadingSuggestions = false;
  Timer? _debounce;
  final _dio = Dio();

  // ── lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
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

  LatLng get _initialPosition => LatLng(
        widget.initialLat ?? _defaultLat,
        widget.initialLng ?? _defaultLng,
      );

  // ── GPS ────────────────────────────────────────────────────────────────────

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

  // ── Search ─────────────────────────────────────────────────────────────────

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
          'language': 'ar',
        },
      );
      final status = res.data['status'] as String;
      final list = status == 'OK' ? res.data['predictions'] as List : [];
      if (!mounted) return;
      setState(() {
        _suggestions = list
            .map((p) => _Suggestion(
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

  Future<void> _selectSuggestion(_Suggestion s) async {
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

  // ── Marker ─────────────────────────────────────────────────────────────────

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

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: [
          // ── Full-screen map ──────────────────────────────────────────────
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 13,
            ),
            onMapCreated: (c) {
              _mapController = c;
              _moveToGps();
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            markers: _markers,
            onTap: (latLng) => _placeMarker(latLng, ''),
          ),

          // ── Search bar / overlay ─────────────────────────────────────────
          SafeArea(
            child: Material(
              type: MaterialType.transparency,
              child: _isSearching
                  ? _SearchOverlay(
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
                  : _SearchBar(
                      text: _searchController.text,
                      onTap: () {
                        setState(() => _isSearching = true);
                        Future.microtask(() => _searchFocus.requestFocus());
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

          // ── My location button ────────────────────────────────────────────
          Positioned(
            left: Insets.s16,
            bottom: widget.showConfirmButton && _pickedLocation != null
                ? 124.h
                : 24.h,
            child: _MyLocationButton(onTap: _moveToGps),
          ),

          // ── Confirm button ────────────────────────────────────────────────
          if (widget.showConfirmButton && _pickedLocation != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _ConfirmButton(
                address: _pickedAddress,
                label: widget.confirmLabel,
                onTap: () => widget.onLocationSelected
                    ?.call(_pickedLocation!, _pickedAddress),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Private sub-widgets ────────────────────────────────────────────────────────

class _Suggestion {
  final String description;
  final String placeId;
  const _Suggestion({required this.description, required this.placeId});
}

class _SearchBar extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _SearchBar({
    required this.text,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: Insets.s16, vertical: Insets.s12),
        height: 48.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.s12),
          boxShadow: const [
            BoxShadow(
                color: AppColors.shadow,
                blurRadius: 10,
                offset: Offset(0, 2))
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: Insets.s12),
        child: Row(
          children: [
            Icon(Icons.search_rounded,
                color: AppColors.primary, size: 22.sp),
            SizedBox(width: Insets.s8),
            Expanded(
              child: Text(
                text.isEmpty ? 'ابحث عن موقع...' : text,
                style: text.isEmpty
                    ? getRegularStyle(
                        color: AppColors.grey,
                        fontSize: FontSize.s14)
                    : getMediumStyle(
                        color: AppColors.black,
                        fontSize: FontSize.s14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (text.isNotEmpty)
              GestureDetector(
                onTap: onClear,
                behavior: HitTestBehavior.opaque,
                child:
                    Icon(Icons.close, color: AppColors.grey, size: 18.sp),
              ),
          ],
        ),
      ),
    );
  }
}

class _SearchOverlay extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<_Suggestion> suggestions;
  final bool isLoading;
  final VoidCallback onBack;
  final VoidCallback onClear;
  final ValueChanged<_Suggestion> onSuggestionTap;
  final VoidCallback onSubmit;

  const _SearchOverlay({
    required this.controller,
    required this.focusNode,
    required this.suggestions,
    required this.isLoading,
    required this.onBack,
    required this.onClear,
    required this.onSuggestionTap,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Input row
        Container(
          color: AppColors.white,
          padding: EdgeInsets.fromLTRB(
              Insets.s16, Insets.s12, Insets.s16, Insets.s12),
          child: Row(
            children: [
              GestureDetector(
                onTap: onBack,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: const BoxDecoration(
                      color: AppColors.lightGrey,
                      shape: BoxShape.circle),
                  child:
                      Icon(Icons.arrow_back, size: 18.sp, color: AppColors.black),
                ),
              ),
              SizedBox(width: Insets.s8),
              Expanded(
                child: Container(
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(AppRadius.s12),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: Insets.s12),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded,
                          color: AppColors.grey, size: 18.sp),
                      SizedBox(width: Insets.s8),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          focusNode: focusNode,
                          autofocus: true,
                          textDirection: TextDirection.rtl,
                          textInputAction: TextInputAction.search,
                          style: getMediumStyle(
                              color: AppColors.black,
                              fontSize: FontSize.s14),
                          decoration: InputDecoration(
                            hintText: 'ابحث عن مدينة أو منطقة...',
                            hintStyle: getRegularStyle(
                                color: AppColors.grey,
                                fontSize: FontSize.s14),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          onSubmitted: (_) => onSubmit(),
                        ),
                      ),
                      if (controller.text.isNotEmpty)
                        GestureDetector(
                          onTap: onClear,
                          behavior: HitTestBehavior.opaque,
                          child: Icon(Icons.close,
                              color: AppColors.grey, size: 16.sp),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Divider
        const Divider(color: AppColors.divider, height: 1),
        // Results
        if (isLoading)
          Container(
            color: AppColors.white,
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: const Center(
              child: CircularProgressIndicator(
                  color: AppColors.primary, strokeWidth: 2),
            ),
          )
        else if (suggestions.isNotEmpty)
          Container(
            color: AppColors.white,
            constraints: BoxConstraints(maxHeight: 300.h),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: suggestions.length,
              separatorBuilder: (_, __) =>
                  const Divider(color: AppColors.divider, height: 1),
              itemBuilder: (_, i) {
                final s = suggestions[i];
                return InkWell(
                  onTap: () => onSuggestionTap(s),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Insets.s16,
                        vertical: Insets.s12),
                    child: Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            color: AppColors.primary, size: 20.sp),
                        SizedBox(width: Insets.s12),
                        Expanded(
                          child: Text(
                            s.description,
                            style: getMediumStyle(
                                color: AppColors.black,
                                fontSize: FontSize.s14),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _MyLocationButton extends StatelessWidget {
  final VoidCallback onTap;
  const _MyLocationButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: const BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: AppColors.shadow,
                blurRadius: 10,
                offset: Offset(0, 3))
          ],
        ),
        child: Icon(Icons.my_location_rounded,
            color: AppColors.primary, size: 22.sp),
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  final String address;
  final String label;
  final VoidCallback onTap;

  const _ConfirmButton({
    required this.address,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          Insets.s16, Insets.s16, Insets.s16, 32.h),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 16,
              offset: Offset(0, -4))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (address.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.location_on,
                    color: AppColors.primary, size: 16.sp),
                SizedBox(width: Insets.s8),
                Expanded(
                  child: Text(
                    address,
                    style: getMediumStyle(
                        color: AppColors.black,
                        fontSize: FontSize.s12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: Insets.s12),
          ],
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppRadius.s12)),
              ),
              child: Text(label,
                  style: getBoldStyle(
                      color: AppColors.white,
                      fontSize: FontSize.s16)),
            ),
          ),
        ],
      ),
    );
  }
}
