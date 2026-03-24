import 'package:flutter/material.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<LocationItem> _results = [];

  final List<LocationItem> _allLocations = const [
    LocationItem(title: 'المنصورة', subtitle: 'أول المنصورة-قسم أول-شارع الحوار'),
    LocationItem(title: 'المنصورة', subtitle: 'أول المنصورة-قسم أول-شارع الحوار'),
    LocationItem(title: 'المنصورة', subtitle: 'أول المنصورة-قسم أول-شارع الحوار'),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    setState(() {
      if (query.isEmpty) {
        _results = [];
      } else {
        _results = _allLocations
            .where((loc) => loc.title.contains(query) || loc.subtitle.contains(query))
            .toList();
        if (_results.isEmpty) _results = List.from(_allLocations);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
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
                onClear: () { _searchController.clear(); setState(() => _results = []); },
              ),
              const Divider(color: AppColors.divider, height: 1),
              const CurrentLocationTile(),
              const Divider(color: AppColors.divider, height: 1),
              ChooseOnMapTile(title: widget.args.title),
              const Divider(color: AppColors.divider, height: 1),
              Expanded(
                child: _searchController.text.isEmpty
                    ? const SizedBox.shrink()
                    : LocationResultsList(items: _results.isEmpty ? _allLocations : _results),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
