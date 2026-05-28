import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_gofull/core/cubits/location_cubit.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/utils/gps_utils.dart';
import '../../data/nominatim_service.dart';
import '../../domain/nominatim_result.dart';
import '../widgets/picker/picker_confirm_card.dart';
import '../widgets/picker/picker_map.dart';
import '../widgets/picker/picker_my_location_btn.dart';
import '../widgets/picker/picker_search_overlay.dart';
import '../widgets/picker/picker_top_bar.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

/// Default fallback: Benghazi, Libya
const _kDefaultLocation = LatLng(32.1194, 20.0868);

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});
  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _ctrl;
  LatLng? _center; // null until we know where the user is
  String _address = '';
  bool _loadingAddr = false, _searching = false, _loadingSugg = false;
  bool _resolvingGps = true; // true while we fetch the real GPS
  List<NominatimResult> _suggestions = [];
  final _searchCtrl = TextEditingController();
  final _searchFocus = FocusNode();
  final _service = NominatimService();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearchChanged);
    _resolveInitialLocation();
  }

  /// Determine the initial map center in this priority order:
  /// 1. Previously saved location (from LocationCubit)
  /// 2. Live GPS position
  /// 3. Fallback to Benghazi
  Future<void> _resolveInitialLocation() async {
    // 1) Check if we already have a saved location
    final saved = context.read<LocationCubit>().state;
    if (saved.lat != null && saved.lng != null) {
      setState(() {
        _center = LatLng(saved.lat!, saved.lng!);
        _address = saved.address;
        _resolvingGps = false;
      });
      return;
    }

    // 2) Try getting the real GPS position
    try {
      // Check / request permission
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }

      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        // Permission denied — fall back to default
        if (mounted) {
          setState(() {
            _center = _kDefaultLocation;
            _resolvingGps = false;
          });
        }
        return;
      }

      // Make sure location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            _center = _kDefaultLocation;
            _resolvingGps = false;
          });
        }
        return;
      }

      // Get the actual position
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      if (mounted) {
        setState(() {
          _center = LatLng(pos.latitude, pos.longitude);
          _resolvingGps = false;
        });
        // Reverse geocode the live position
        _reverseGeocode(_center!);
      }
    } catch (_) {
      // GPS timed out or any other error — use default
      if (mounted) {
        setState(() {
          _center = _kDefaultLocation;
          _resolvingGps = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    _searchFocus.dispose();
    _ctrl?.dispose();
    _service.dispose();
    super.dispose();
  }

  Future<void> _reverseGeocode(LatLng pos) async {
    setState(() => _loadingAddr = true);
    try {
      final name = await _service.reverseGeocode(pos);
      if (mounted) setState(() { _address = name; _loadingAddr = false; });
    } catch (_) {
      if (mounted) setState(() => _loadingAddr = false);
    }
  }

  void _onSearchChanged() {
    final q = _searchCtrl.text.trim();
    if (q.isEmpty) { setState(() => _suggestions = []); return; }
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() => _loadingSugg = true);
      try {
        final r = await _service.search(q);
        if (mounted) setState(() { _suggestions = r; _loadingSugg = false; });
      } catch (_) {
        if (mounted) setState(() => _loadingSugg = false);
      }
    });
  }

  void _select(NominatimResult r) {
    final ll = LatLng(r.lat, r.lng);
    _searchFocus.unfocus();
    setState(() { _searching = false; _suggestions = []; _address = r.title; _center = ll; });
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _ctrl?.animateCamera(CameraUpdate.newLatLngZoom(ll, 15)));
  }

  void _confirm() {
    if (_center == null) return;
    context.read<LocationCubit>().setLocation(
        _address.isNotEmpty ? _address : S.of(context).selectedLocationLabel,
        _center!.latitude,
        _center!.longitude);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading spinner while resolving GPS
    if (_resolvingGps || _center == null) {
      return Scaffold(
        backgroundColor: context.colors.background,
        body: Center(
          child: CircularProgressIndicator(color: context.colors.primary),
        ),
      );
    }

    return Scaffold(body: Stack(children: [
      PickerMap(
        initialPosition: _center!,
        onMapCreated: (c) => _ctrl = c,
        onCameraMove: (p) => _center = p.target,
        onCameraIdle: () => _reverseGeocode(_center!),
      ),
      if (!_searching)
        SafeArea(child: Material(type: MaterialType.transparency,
          child: PickerTopBar(
            onBack: () => Navigator.pop(context),
            onSearchTap: () {
              setState(() => _searching = true);
              Future.microtask(() => _searchFocus.requestFocus());
            }))),
      if (_searching)
        Positioned(top: 0, left: 0, right: 0,
          child: Material(color: context.colors.surface, child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            PickerSearchOverlay(controller: _searchCtrl, focusNode: _searchFocus,
              suggestions: _suggestions, isLoading: _loadingSugg,
              onBack: () { setState(() { _searching = false; _suggestions = []; }); _searchFocus.unfocus(); },
              onClear: () { _searchCtrl.clear(); setState(() => _suggestions = []); },
              onSelect: _select),
          ]))),
      PositionedDirectional(start: Insets.s16, bottom: 140.h,
        child: PickerMyLocationBtn(onTap: () => animateToCurrentLocation(_ctrl))),
      Positioned(left: 0, right: 0, bottom: 0,
        child: PickerConfirmCard(address: _address, isLoading: _loadingAddr, onConfirm: _confirm)),
    ]));
  }
}
