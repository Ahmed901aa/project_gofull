import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_gofull/core/cubits/location_cubit.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import '../../data/nominatim_service.dart';
import '../../domain/nominatim_result.dart';
import '../widgets/picker/picker_confirm_card.dart';
import '../widgets/picker/picker_map.dart';
import '../widgets/picker/picker_my_location_btn.dart';
import '../widgets/picker/picker_search_overlay.dart';
import '../widgets/picker/picker_top_bar.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});
  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  static const _default = LatLng(24.7136, 46.6753);

  GoogleMapController? _mapController;
  LatLng _center = _default;
  String _address = '';
  bool _isLoadingAddress = false;
  bool _isSearching = false;
  List<NominatimResult> _suggestions = [];
  bool _isLoadingSuggestions = false;

  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  final _service = NominatimService();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final saved = context.read<LocationCubit>().state;
      if (saved.lat != null) setState(() { _center = LatLng(saved.lat!, saved.lng!); _address = saved.address; });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocus.dispose();
    _mapController?.dispose();
    _service.dispose();
    super.dispose();
  }

  Future<void> _goToMyLocation() async {
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
    if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) return;
    try {
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high, timeLimit: const Duration(seconds: 10));
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(pos.latitude, pos.longitude), 15));
    } catch (_) {}
  }

  Future<void> _reverseGeocode(LatLng pos) async {
    setState(() => _isLoadingAddress = true);
    try {
      final name = await _service.reverseGeocode(pos);
      if (mounted) setState(() { _address = name; _isLoadingAddress = false; });
    } catch (_) { if (mounted) setState(() => _isLoadingAddress = false); }
  }

  void _onSearchChanged() {
    final q = _searchController.text.trim();
    if (q.isEmpty) { setState(() => _suggestions = []); return; }
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() => _isLoadingSuggestions = true);
      try {
        final results = await _service.search(q);
        if (mounted) setState(() { _suggestions = results; _isLoadingSuggestions = false; });
      } catch (_) { if (mounted) setState(() => _isLoadingSuggestions = false); }
    });
  }

  void _selectSuggestion(NominatimResult r) {
    final latLng = LatLng(r.lat, r.lng);
    _searchFocus.unfocus();
    setState(() { _isSearching = false; _suggestions = []; _address = r.title; _center = latLng; });
    WidgetsBinding.instance.addPostFrameCallback((_) => _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15)));
  }

  void _confirm() {
    context.read<LocationCubit>().setLocation(_address.isNotEmpty ? _address : 'موقع محدد', _center.latitude, _center.longitude);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PickerMap(initialPosition: _center,
          onMapCreated: (c) { _mapController = c; _goToMyLocation(); },
          onCameraMove: (pos) => _center = pos.target,
          onCameraIdle: () => _reverseGeocode(_center),
        ),
        if (!_isSearching)
          SafeArea(child: Material(type: MaterialType.transparency,
            child: PickerTopBar(
              onBack: () => Navigator.pop(context),
              onSearchTap: () { setState(() => _isSearching = true); Future.microtask(() => _searchFocus.requestFocus()); },
            ))),
        if (_isSearching)
          Positioned(top: 0, left: 0, right: 0,
            child: Material(color: Colors.white,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                PickerSearchOverlay(
                  controller: _searchController, focusNode: _searchFocus,
                  suggestions: _suggestions, isLoading: _isLoadingSuggestions,
                  onBack: () { setState(() { _isSearching = false; _suggestions = []; }); _searchFocus.unfocus(); },
                  onClear: () { _searchController.clear(); setState(() => _suggestions = []); },
                  onSelect: _selectSuggestion,
                ),
              ]),
            )),
        Positioned(left: Insets.s16, bottom: 140.h, child: PickerMyLocationBtn(onTap: _goToMyLocation)),
        Positioned(left: 0, right: 0, bottom: 0,
          child: PickerConfirmCard(address: _address, isLoading: _isLoadingAddress, onConfirm: _confirm)),
      ]),
    );
  }
}
