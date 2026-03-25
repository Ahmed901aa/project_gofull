import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_gofull/core/cubits/location_cubit.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/utils/gps_utils.dart';
import '../../data/google_places_service.dart';
import '../widgets/picker/picker_confirm_card.dart';
import '../widgets/picker/picker_map.dart';
import '../widgets/picker/picker_my_location_btn.dart';
import '../widgets/picker/picker_search_overlay.dart';
import '../widgets/picker/picker_top_bar.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});
  @override State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _ctrl;
  LatLng _center = const LatLng(24.7136, 46.6753);
  String _address = '';
  bool _loadingAddr = false, _searching = false, _loadingSugg = false;
  List<PlacePrediction> _suggestions = [];
  final _searchCtrl = TextEditingController();
  final _searchFocus = FocusNode();
  final _places = GooglePlacesService();
  Timer? _debounce;
  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final s = context.read<LocationCubit>().state;
      if (s.lat != null) setState(() { _center = LatLng(s.lat!, s.lng!); _address = s.address; });
    });
  }
  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    _searchFocus.dispose();
    _ctrl?.dispose();
    _places.dispose();
    super.dispose();
  }
  Future<void> _reverseGeocode(LatLng pos) async {
    setState(() => _loadingAddr = true);
    try {
      final name = await _places.reverseGeocode(pos.latitude, pos.longitude);
      if (mounted) setState(() { _address = name; _loadingAddr = false; });
    } catch (_) { if (mounted) setState(() => _loadingAddr = false); }
  }
  void _onSearchChanged() {
    final q = _searchCtrl.text.trim();
    if (q.isEmpty) { setState(() => _suggestions = []); return; }
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() => _loadingSugg = true);
      final r = await _places.autocomplete(q);
      if (mounted) setState(() { _suggestions = r; _loadingSugg = false; });
    });
  }
  void _onSelect(PlacePrediction p) { _selectAndMove(p); }
  Future<void> _selectAndMove(PlacePrediction p) async {
    final detail = await _places.getDetails(p.placeId);
    if (detail == null || !mounted) return;
    final ll = LatLng(detail.lat, detail.lng);
    _searchFocus.unfocus();
    setState(() { _searching = false; _suggestions = []; _address = detail.address; _center = ll; });
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _ctrl?.animateCamera(CameraUpdate.newLatLngZoom(ll, 15)));
  }
  void _confirm() {
    context.read<LocationCubit>().setLocation(
        _address.isNotEmpty ? _address : 'موقع محدد', _center.latitude, _center.longitude);
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [
      PickerMap(initialPosition: _center,
        onMapCreated: (c) { _ctrl = c; animateToCurrentLocation(_ctrl); },
        onCameraMove: (p) => _center = p.target,
        onCameraIdle: () => _reverseGeocode(_center)),
      if (!_searching)
        SafeArea(child: Material(type: MaterialType.transparency,
          child: PickerTopBar(
            onBack: () => Navigator.pop(context),
            onSearchTap: () { setState(() => _searching = true); Future.microtask(() => _searchFocus.requestFocus()); }))),
      if (_searching)
        Positioned(top: 0, left: 0, right: 0,
          child: Material(color: Colors.white, child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            PickerSearchOverlay(controller: _searchCtrl, focusNode: _searchFocus,
              suggestions: _suggestions, isLoading: _loadingSugg,
              onBack: () { setState(() { _searching = false; _suggestions = []; }); _searchFocus.unfocus(); },
              onClear: () { _searchCtrl.clear(); setState(() => _suggestions = []); },
              onSelect: _onSelect),
          ]))),
      Positioned(left: Insets.s16, bottom: 140.h,
        child: PickerMyLocationBtn(onTap: () => animateToCurrentLocation(_ctrl))),
      Positioned(left: 0, right: 0, bottom: 0,
        child: PickerConfirmCard(address: _address, isLoading: _loadingAddr, onConfirm: _confirm)),
    ]));
  }
}
