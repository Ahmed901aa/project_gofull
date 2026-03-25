import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_gofull/core/cubits/location_cubit.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/gps_utils.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import '../../data/nominatim_service.dart';
import '../widgets/location_option_tile.dart';
import '../widgets/location_results_list.dart';
import '../widgets/location_search_app_bar.dart';
import '../widgets/location_search_bar.dart';

class LocationSearchScreen extends StatefulWidget {
  final LocationSearchArgs args;
  const LocationSearchScreen({super.key, required this.args});
  @override State<LocationSearchScreen> createState() => _State();
}

class _State extends State<LocationSearchScreen> {
  static const _apiKey = 'AIzaSyDZ_ZezX058d36aMTOc9E--MbyWqCdOI9I';
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  final _dio = Dio();
  final _nominatim = NominatimService();
  List<LocationItem> _results = [];
  bool _isLoading = false;
  Timer? _debounce;
  @override
  void initState() { super.initState(); _ctrl.addListener(_onChanged); }
  @override
  void dispose() {
    _debounce?.cancel(); _ctrl.dispose(); _focus.dispose();
    _dio.close(); _nominatim.dispose(); super.dispose();
  }
  void _onChanged() {
    final q = _ctrl.text.trim();
    if (q.length < 2) { setState(() => _results = []); return; }
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () => _search(q));
  }
  Future<void> _search(String q) async {
    setState(() => _isLoading = true);
    try {
      final res = await _dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {'address': q, 'key': _apiKey, 'language': 'ar'},
      );
      final list = res.data['status'] == 'OK' ? res.data['results'] as List : [];
      setState(() {
        _results = list.map<LocationItem>((r) {
          final desc = r['formatted_address'] as String;
          final parts = desc.split('،');
          return LocationItem(
            title: parts.first.trim(),
            subtitle: parts.length > 1 ? parts.skip(1).join('،').trim() : '',
            placeId: '${r['geometry']['location']['lat']},${r['geometry']['location']['lng']}',
          );
        }).toList();
        _isLoading = false;
      });
    } catch (_) { setState(() => _isLoading = false); }
  }
  void _onResultTap(LocationItem item) {
    if (item.placeId == null) return;
    final p = item.placeId!.split(',');
    context.read<LocationCubit>()
        .setLocation(item.title, double.parse(p[0]), double.parse(p[1]));
    Navigator.pop(context);
  }
  Future<void> _onGpsTap() async {
    final loc = await fetchCurrentGpsLocation(_nominatim);
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(child: Column(children: [
          LocationSearchAppBar(onClose: () => Navigator.pop(context)),
          LocationSearchBar(controller: _ctrl, focusNode: _focus,
            onClear: () { _ctrl.clear(); setState(() => _results = []); }),
          const Divider(color: AppColors.neutral500, height: 1),
          LocationOptionTile(onGpsTap: _onGpsTap, onMapTap: _onMapTap),
          const Divider(color: AppColors.neutral500, height: 1),
          if (hasQuery && _isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator(
                color: AppColors.primary, strokeWidth: 2))),
          if (hasQuery && !_isLoading)
            Expanded(child: LocationResultsList(
                items: _results, onItemTap: _onResultTap)),
        ])),
      ),
    );
  }
}
