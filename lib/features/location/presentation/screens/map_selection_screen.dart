import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import '../widgets/map_address_bar.dart';
import '../widgets/map_confirm_button.dart';
import '../widgets/map_my_location_button.dart';
import '../widgets/map_top_bar.dart';

class MapSelectionScreen extends StatefulWidget {
  final MapSelectionArgs args;
  const MapSelectionScreen({super.key, required this.args});

  @override
  State<MapSelectionScreen> createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  static const _apiKey = 'AIzaSyDZ_ZezX058d36aMTOc9E--MbyWqCdOI9I';

  GoogleMapController? _mapController;
  late LatLng _selectedLocation;
  String _address = '';

  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _searchResults = [];
  bool _isSearchLoading = false;
  final _dio = Dio();

  @override
  void initState() {
    super.initState();
    _selectedLocation = LatLng(
      widget.args.initialLat ?? 32.9022,
      widget.args.initialLng ?? 13.1800,
    );
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    _dio.close();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.length < 2) {
      setState(() => _searchResults = []);
      return;
    }
    _searchPlaces(query);
  }

  Future<void> _searchPlaces(String query) async {
    setState(() => _isSearchLoading = true);
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json',
        queryParameters: {
          'input': query,
          'key': _apiKey,
          'language': 'ar',
          'components': 'country:ly',
        },
      );
      final predictions = response.data['predictions'] as List;
      if (!mounted) return;
      setState(() {
        _searchResults = predictions
            .map((p) => {
                  'description': p['description'] as String,
                  'placeId': p['place_id'] as String,
                })
            .toList();
        _isSearchLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isSearchLoading = false);
    }
  }

  Future<void> _selectPlace(String placeId, String description) async {
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/details/json',
        queryParameters: {'place_id': placeId, 'fields': 'geometry', 'key': _apiKey},
      );
      final loc = response.data['result']['geometry']['location'];
      final latLng = LatLng(
        (loc['lat'] as num).toDouble(),
        (loc['lng'] as num).toDouble(),
      );
      if (!mounted) return;
      setState(() {
        _selectedLocation = latLng;
        _address = description;
        _isSearching = false;
        _searchController.clear();
        _searchResults = [];
      });
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));
    } catch (_) {}
  }

  Future<void> _updateAddress() async {
    try {
      final placemarks = await placemarkFromCoordinates(
        _selectedLocation.latitude,
        _selectedLocation.longitude,
      );
      if (placemarks.isNotEmpty && mounted) {
        final p = placemarks.first;
        final parts = [p.street, p.subLocality, p.locality]
            .where((s) => s != null && s.isNotEmpty)
            .toList();
        setState(() => _address = parts.isNotEmpty ? parts.join('، ') : '');
      }
    } catch (_) {}
  }

  Future<void> _goToMyLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) return;
      final position = await Geolocator.getCurrentPosition();
      final latLng = LatLng(position.latitude, position.longitude);
      if (!mounted) return;
      setState(() => _selectedLocation = latLng);
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Stack(
          children: [
            // Map
            GoogleMap(
              initialCameraPosition: CameraPosition(target: _selectedLocation, zoom: 15),
              onMapCreated: (controller) => _mapController = controller,
              onCameraMove: (position) => _selectedLocation = position.target,
              onCameraIdle: _updateAddress,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),
            // Centre pin
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 48.h),
                child: Icon(Icons.location_on, size: 52.sp, color: AppColors.primary),
              ),
            ),
            // Top bar + address bar (hidden while searching)
            if (!_isSearching)
              Material(
                type: MaterialType.transparency,
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MapTopBar(
                        onSearchTap: () => setState(() => _isSearching = true),
                      ),
                      MapAddressBar(
                        address: _address,
                        onSearchTap: () => setState(() => _isSearching = true),
                      ),
                    ],
                  ),
                ),
              ),
            // Search overlay
            if (_isSearching)
              Material(
                type: MaterialType.transparency,
                child: SafeArea(
                child: Column(
                  children: [
                    // Search input row
                    Container(
                      color: AppColors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: Insets.s16, vertical: Insets.s12),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => setState(() {
                              _isSearching = false;
                              _searchController.clear();
                              _searchResults = [];
                            }),
                            child: Container(
                              width: 36.w,
                              height: 36.w,
                              decoration: BoxDecoration(
                                  color: AppColors.lightGrey,
                                  shape: BoxShape.circle),
                              child: Icon(Icons.arrow_back,
                                  size: 18.sp, color: AppColors.black),
                            ),
                          ),
                          SizedBox(width: Insets.s8),
                          Expanded(
                            child: Container(
                              height: 40.h,
                              padding: EdgeInsets.symmetric(
                                  horizontal: Insets.s12),
                              decoration: BoxDecoration(
                                color: AppColors.lightGrey,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.s12),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.search_rounded,
                                      color: AppColors.grey, size: 18.sp),
                                  SizedBox(width: Insets.s8),
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      autofocus: true,
                                      textDirection: TextDirection.rtl,
                                      style: getMediumStyle(
                                          color: AppColors.black,
                                          fontSize: FontSize.s14),
                                      decoration: InputDecoration(
                                        hintText: 'ابحث عن موقع...',
                                        hintStyle: getRegularStyle(
                                            color: AppColors.grey,
                                            fontSize: FontSize.s14),
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 10.h),
                                      ),
                                    ),
                                  ),
                                  if (_searchController.text.isNotEmpty)
                                    GestureDetector(
                                      onTap: () {
                                        _searchController.clear();
                                        setState(() => _searchResults = []);
                                      },
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
                    // Results list
                    Expanded(
                      child: Container(
                        color: AppColors.white,
                        child: _isSearchLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _searchResults.isEmpty
                                ? Center(
                                    child: Text(
                                      'اكتب للبحث عن موقع',
                                      style: getRegularStyle(
                                          color: AppColors.grey,
                                          fontSize: FontSize.s14),
                                    ),
                                  )
                                : ListView.separated(
                                    itemCount: _searchResults.length,
                                    separatorBuilder: (_, __) => const Divider(
                                        color: AppColors.divider, height: 1),
                                    itemBuilder: (context, index) {
                                      final result = _searchResults[index];
                                      return InkWell(
                                        onTap: () => _selectPlace(
                                            result['placeId']!,
                                            result['description']!),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Insets.s16,
                                              vertical: Insets.s12),
                                          child: Row(
                                            children: [
                                              Icon(Icons.location_on_outlined,
                                                  color: AppColors.primary,
                                                  size: 20.sp),
                                              SizedBox(width: Insets.s12),
                                              Expanded(
                                                child: Text(
                                                  result['description']!,
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
                    ),
                  ],
                ),
              ),
            ),
            // My location button
            if (!_isSearching)
              Positioned(
                left: Insets.s16,
                bottom: 110.h,
                child: MapMyLocationButton(onTap: _goToMyLocation),
              ),
            // Confirm button
            if (!_isSearching)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: MapConfirmButton(address: _address),
              ),
          ],
        ),
      ),
    );
  }
}
