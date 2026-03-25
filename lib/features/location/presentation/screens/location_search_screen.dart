import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import '../widgets/location_option_tile.dart';
import '../widgets/location_results_list.dart';
import '../widgets/location_search_app_bar.dart';
import '../widgets/location_search_bar.dart';

class LocationSearchScreen extends StatefulWidget {
  final LocationSearchArgs args;
  const LocationSearchScreen({super.key, required this.args});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  static const _apiKey = 'AIzaSyDZ_ZezX058d36aMTOc9E--MbyWqCdOI9I';

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _dio = Dio();

  List<LocationItem> _results = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.length < 2) {
      setState(() => _results = []);
      return;
    }
    _searchPlaces(query);
  }

  Future<void> _searchPlaces(String query) async {
    setState(() => _isLoading = true);
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {
          'address': query,
          'key': _apiKey,
          'language': 'ar',
          'region': 'LY',
        },
      );
      final status = response.data['status'] as String;
      final results = status == 'OK' ? response.data['results'] as List : [];
      setState(() {
        _results = results.map<LocationItem>((r) {
          final description = r['formatted_address'] as String;
          final parts = description.split('،');
          return LocationItem(
            title: parts.first.trim(),
            subtitle: parts.length > 1 ? parts.skip(1).join('،').trim() : description,
            placeId: '${r['geometry']['location']['lat']},${r['geometry']['location']['lng']}',
          );
        }).toList();
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _onResultTap(LocationItem item) async {
    if (item.placeId == null) return;
    final parts = item.placeId!.split(',');
    final lat = double.parse(parts[0]);
    final lng = double.parse(parts[1]);
    if (!mounted) return;
    final address = await Navigator.pushNamed(
      context,
      Routes.mapSelection,
      arguments: MapSelectionArgs(
        title: widget.args.title,
        initialLat: lat,
        initialLng: lng,
      ),
    );
    if (address != null && mounted) {
      Navigator.pop(context, address);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _dio.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              LocationSearchAppBar(title: widget.args.title),
              LocationSearchBar(
                controller: _searchController,
                focusNode: _focusNode,
                onClear: () {
                  _searchController.clear();
                  setState(() => _results = []);
                },
              ),
              const Divider(color: AppColors.divider, height: 1),
              const CurrentLocationTile(),
              const Divider(color: AppColors.divider, height: 1),
              ChooseOnMapTile(title: widget.args.title),
              const Divider(color: AppColors.divider, height: 1),
              Expanded(
                child: _searchController.text.isEmpty
                    ? const SizedBox.shrink()
                    : _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : LocationResultsList(
                            items: _results,
                            onItemTap: _onResultTap,
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
