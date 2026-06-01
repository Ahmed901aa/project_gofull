import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_gofull/core/cubits/location_cubit.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/gps_utils.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import '../../data/nominatim_service.dart';
import '../widgets/location_option_tile.dart';
import '../widgets/location_results_list.dart';
import '../widgets/location_search_app_bar.dart';
import '../widgets/location_search_bar.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

class LocationSearchScreen extends StatefulWidget {
  final LocationSearchArgs args;
  const LocationSearchScreen({super.key, required this.args});
  @override State<LocationSearchScreen> createState() => _State();
}

class _State extends State<LocationSearchScreen> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  final _service = NominatimService();
  List<LocationItem> _results = [];
  bool _isLoading = false;
  Timer? _debounce;

  @override
  void initState() { super.initState(); _ctrl.addListener(_onChanged); }

  @override
  void dispose() {
    _debounce?.cancel(); _ctrl.dispose(); _focus.dispose();
    _service.dispose(); super.dispose();
  }

  void _onChanged() {
    final q = _ctrl.text.trim();
    if (q.isEmpty) { setState(() => _results = []); return; }
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () => _search(q));
  }

  Future<void> _search(String q) async {
    setState(() => _isLoading = true);
    try {
      final r = await _service.search(q);
      if (!mounted) {

        return;

      }
      setState(() {
        _results = r
            .map((n) => LocationItem(title: n.title, subtitle: n.subtitle,
                lat: n.lat, lng: n.lng))
            .toList();
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onResultTap(LocationItem item) {
    context.read<LocationCubit>()
        .setLocation(item.title, item.lat!, item.lng!);
    Navigator.pop(context);
  }

  Future<void> _onGpsTap() async {
    final loc = await fetchCurrentGpsLocation(
        (lat, lng) => _service.reverseGeocode(LatLng(lat, lng)));
    if (loc != null && mounted) {
      context.read<LocationCubit>()
          .setLocation(loc.address, loc.lat, loc.lng);
      Navigator.pop(context);
    }
  }

  Future<void> _onMapTap() async {
    await Navigator.pushNamed(context, Routes.locationPicker);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final hasQuery = _ctrl.text.isNotEmpty;
    return Scaffold(
        backgroundColor: context.colors.surface,
        resizeToAvoidBottomInset: true,
        body: SafeArea(child: Column(children: [
          LocationSearchAppBar(onClose: () => Navigator.pop(context)),
          LocationSearchBar(controller: _ctrl, focusNode: _focus,
            onClear: () { _ctrl.clear(); setState(() => _results = []); }),
          Divider(color: context.colors.border, height: 1),
          LocationOptionTile(onGpsTap: _onGpsTap, onMapTap: _onMapTap),
          Divider(color: context.colors.border, height: 1),
          if (hasQuery && _isLoading)
            Expanded(child: Center(child: CircularProgressIndicator(
                color: context.colors.primary, strokeWidth: 2))),
          if (hasQuery && !_isLoading)
            Expanded(child: LocationResultsList(
                items: _results, onItemTap: _onResultTap)),
        ])),
      );
  }
}
