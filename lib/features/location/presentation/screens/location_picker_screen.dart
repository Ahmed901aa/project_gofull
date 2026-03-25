import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_gofull/core/cubits/location_cubit.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  // Default: Riyadh
  static const _defaultPosition = LatLng(24.7136, 46.6753);

  GoogleMapController? _mapController;
  LatLng _center = _defaultPosition;
  String _address = '';
  bool _isLoadingAddress = false;

  // Search
  bool _isSearching = false;
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  List<_NominatimResult> _suggestions = [];
  bool _isLoadingSuggestions = false;
  Timer? _debounce;

  final _dio = Dio(BaseOptions(
    headers: {'User-Agent': 'GoFullApp/1.0'},
  ));

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    // Start at previously saved location if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final saved = context.read<LocationCubit>().state;
      if (saved.lat != null && saved.lng != null) {
        _center = LatLng(saved.lat!, saved.lng!);
        _address = saved.address;
        setState(() {});
      }
    });
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

  // ── GPS ────────────────────────────────────────────────────────────────────

  Future<void> _goToMyLocation() async {
    try {
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) return;
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
            LatLng(pos.latitude, pos.longitude), 15),
      );
    } catch (_) {}
  }

  // ── Reverse geocoding (Nominatim) ──────────────────────────────────────────

  Future<void> _reverseGeocode(LatLng pos) async {
    setState(() => _isLoadingAddress = true);
    try {
      final res = await _dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'format': 'json',
          'lat': pos.latitude,
          'lon': pos.longitude,
          'accept-language': 'ar',
        },
      );
      if (!mounted) return;
      final name = _extractName(res.data);
      setState(() {
        _address = name;
        _isLoadingAddress = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoadingAddress = false);
    }
  }

  String _extractName(Map<String, dynamic> data) {
    final addr = data['address'] as Map<String, dynamic>?;
    if (addr == null) return data['display_name'] as String? ?? '';
    return [
      addr['neighbourhood'],
      addr['suburb'],
      addr['city'] ?? addr['town'] ?? addr['village'],
    ].where((s) => s != null && (s as String).isNotEmpty).join('، ');
  }

  // ── Search (Nominatim) ─────────────────────────────────────────────────────

  void _onSearchChanged() {
    final q = _searchController.text.trim();
    if (q.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => _fetchSuggestions(q),
    );
  }

  Future<void> _fetchSuggestions(String query) async {
    setState(() => _isLoadingSuggestions = true);
    try {
      final res = await _dio.get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {
          'format': 'json',
          'q': query,
          'accept-language': 'ar',
          'limit': '6',
        },
      );
      if (!mounted) return;
      final list = res.data as List;
      setState(() {
        _suggestions = list
            .map((r) => _NominatimResult(
                  displayName: r['display_name'] as String,
                  lat: double.parse(r['lat'] as String),
                  lng: double.parse(r['lon'] as String),
                ))
            .toList();
        _isLoadingSuggestions = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoadingSuggestions = false);
    }
  }

  void _selectSuggestion(_NominatimResult result) {
    _searchFocus.unfocus();
    final latLng = LatLng(result.lat, result.lng);
    setState(() {
      _isSearching = false;
      _suggestions = [];
      _searchController.text = result.displayName.split(',').first.trim();
      _address = result.displayName.split(',').first.trim();
      _center = latLng;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(latLng, 15));
    });
  }

  // ── Confirm ────────────────────────────────────────────────────────────────

  void _confirm() {
    final address = _address.isNotEmpty ? _address : 'موقع محدد';
    context
        .read<LocationCubit>()
        .setLocation(address, _center.latitude, _center.longitude);
    Navigator.pop(context);
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Map ────────────────────────────────────────────────────────────
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: _center, zoom: 13),
            onMapCreated: (c) {
              _mapController = c;
              _goToMyLocation();
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onCameraMove: (pos) => _center = pos.target,
            onCameraIdle: () => _reverseGeocode(_center),
          ),

          // ── Fixed centre pin ───────────────────────────────────────────────
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on,
                    color: AppColors.primary, size: 48.sp),
                // small shadow dot under pin
                Container(
                  width: 8.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                // push the pin up so its tip is at map center
                SizedBox(height: 52.h),
              ],
            ),
          ),

          // ── Top bar ────────────────────────────────────────────────────────
          SafeArea(
            child: Material(
              type: MaterialType.transparency,
              child: _isSearching
                  ? _buildSearchOverlay()
                  : _buildTopBar(),
            ),
          ),

          // ── My location button ─────────────────────────────────────────────
          Positioned(
            left: Insets.s16,
            bottom: 140.h,
            child: _buildMyLocationBtn(),
          ),

          // ── Bottom confirm card ────────────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildConfirmCard(),
          ),
        ],
      ),
    );
  }

  // ── Top bar (collapsed) ────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Insets.s16, vertical: Insets.s12),
      child: Row(
        children: [
          // Back
          GestureDetector(
            onTap: () => Navigator.pop(context),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: const BoxDecoration(
                  color: AppColors.white, shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8)]),
              child: Icon(Icons.arrow_back,
                  size: 20.sp, color: AppColors.black),
            ),
          ),
          SizedBox(width: Insets.s12),
          // Search bar (read-only, opens search on tap)
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _isSearching = true);
                Future.microtask(() => _searchFocus.requestFocus());
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 44.h,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.s12),
                  boxShadow: const [
                    BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 8,
                        offset: Offset(0, 2))
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: Insets.s12),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded,
                        color: AppColors.primary, size: 20.sp),
                    SizedBox(width: Insets.s8),
                    Expanded(
                      child: Text(
                        'ابحث عن موقع...',
                        style: getRegularStyle(
                            color: AppColors.grey,
                            fontSize: FontSize.s14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Search overlay (expanded) ──────────────────────────────────────────────

  Widget _buildSearchOverlay() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: AppColors.white,
          padding: EdgeInsets.fromLTRB(
              Insets.s16, Insets.s12, Insets.s16, Insets.s12),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isSearching = false;
                    _suggestions = [];
                  });
                  _searchFocus.unfocus();
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: const BoxDecoration(
                      color: AppColors.lightGrey,
                      shape: BoxShape.circle),
                  child: Icon(Icons.arrow_back,
                      size: 18.sp, color: AppColors.black),
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
                          controller: _searchController,
                          focusNode: _searchFocus,
                          autofocus: true,
                          textDirection: TextDirection.rtl,
                          textInputAction: TextInputAction.search,
                          style: getMediumStyle(
                              color: AppColors.black,
                              fontSize: FontSize.s14),
                          decoration: InputDecoration(
                            hintText: 'ابحث عن مدينة أو حي...',
                            hintStyle: getRegularStyle(
                                color: AppColors.grey,
                                fontSize: FontSize.s14),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.h),
                          ),
                          onSubmitted: (_) {
                            if (_suggestions.isNotEmpty) {
                              _selectSuggestion(_suggestions.first);
                            }
                          },
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            setState(() => _suggestions = []);
                          },
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
        const Divider(color: AppColors.divider, height: 1),
        if (_isLoadingSuggestions)
          Container(
            color: AppColors.white,
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: const Center(
              child: CircularProgressIndicator(
                  color: AppColors.primary, strokeWidth: 2),
            ),
          )
        else if (_suggestions.isNotEmpty)
          Container(
            color: AppColors.white,
            constraints: BoxConstraints(maxHeight: 300.h),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _suggestions.length,
              separatorBuilder: (_, __) =>
                  const Divider(color: AppColors.divider, height: 1),
              itemBuilder: (_, i) {
                final s = _suggestions[i];
                final title = s.displayName.split(',').first.trim();
                final subtitle = s.displayName
                    .split(',')
                    .skip(1)
                    .join(',')
                    .trim();
                return InkWell(
                  onTap: () => _selectSuggestion(s),
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
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(title,
                                  style: getMediumStyle(
                                      color: AppColors.black,
                                      fontSize: FontSize.s14)),
                              if (subtitle.isNotEmpty)
                                Text(subtitle,
                                    style: getRegularStyle(
                                        color: AppColors.grey,
                                        fontSize: FontSize.s12),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                            ],
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

  // ── My location button ─────────────────────────────────────────────────────

  Widget _buildMyLocationBtn() {
    return GestureDetector(
      onTap: _goToMyLocation,
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

  // ── Confirm card ───────────────────────────────────────────────────────────

  Widget _buildConfirmCard() {
    return Container(
      padding:
          EdgeInsets.fromLTRB(Insets.s16, Insets.s16, Insets.s16, 36.h),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 20,
              offset: Offset(0, -4))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Address row
          Row(
            children: [
              Icon(Icons.location_on,
                  color: AppColors.primary, size: 18.sp),
              SizedBox(width: Insets.s8),
              Expanded(
                child: _isLoadingAddress
                    ? Row(
                        children: [
                          SizedBox(
                            width: 14.w,
                            height: 14.w,
                            child: const CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 2),
                          ),
                          SizedBox(width: Insets.s8),
                          Text('جارٍ تحديد الموقع...',
                              style: getRegularStyle(
                                  color: AppColors.grey,
                                  fontSize: FontSize.s14)),
                        ],
                      )
                    : Text(
                        _address.isNotEmpty
                            ? _address
                            : 'حرّك الخريطة لاختيار موقعك',
                        style: getMediumStyle(
                            color: AppColors.black,
                            fontSize: FontSize.s14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
            ],
          ),
          SizedBox(height: Insets.s16),
          // Confirm button
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: _confirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppRadius.s12)),
              ),
              child: Text('تأكيد الموقع',
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

class _NominatimResult {
  final String displayName;
  final double lat;
  final double lng;
  const _NominatimResult(
      {required this.displayName,
      required this.lat,
      required this.lng});
}
