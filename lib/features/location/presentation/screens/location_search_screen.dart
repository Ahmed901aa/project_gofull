import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';

class LocationSearchScreen extends StatefulWidget {
  final LocationSearchArgs args;
  const LocationSearchScreen({super.key, required this.args});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<_LocationItem> _results = [];

  final List<_LocationItem> _allLocations = const [
    _LocationItem(
      title: 'المنصورة',
      subtitle: 'أول المنصورة-قسم أول-شارع الحوار',
    ),
    _LocationItem(
      title: 'المنصورة',
      subtitle: 'أول المنصورة-قسم أول-شارع الحوار',
    ),
    _LocationItem(
      title: 'المنصورة',
      subtitle: 'أول المنصورة-قسم أول-شارع الحوار',
    ),
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
            .where(
              (loc) =>
                  loc.title.contains(query) || loc.subtitle.contains(query),
            )
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
              _buildAppBar(),
              _buildSearchBar(),
              const Divider(color: AppColors.divider, height: 1),
              _buildCurrentLocationOption(),
              const Divider(color: AppColors.divider, height: 1),
              _buildChooseOnMapOption(),
              const Divider(color: AppColors.divider, height: 1),
              Expanded(
                child: _searchController.text.isEmpty
                    ? const SizedBox.shrink()
                    : _buildResultsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Insets.s16,
        vertical: 14.h,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            widget.args.title,
            style: getBoldStyle(
              color: AppColors.black,
              fontSize: FontSize.s18,
            ),
            textAlign: TextAlign.center,
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  size: 18.sp,
                  color: AppColors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Insets.s16,
        0,
        Insets.s16,
        Insets.s12,
      ),
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: Insets.s12),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(AppRadius.s12),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: AppColors.grey, size: 20.sp),
            SizedBox(width: Insets.s8),
            Expanded(
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                textDirection: TextDirection.rtl,
                style: getMediumStyle(
                  color: AppColors.black,
                  fontSize: FontSize.s14,
                ),
                decoration: InputDecoration(
                  hintText: 'ابحث عن موقعك',
                  hintStyle: getRegularStyle(
                    color: AppColors.grey,
                    fontSize: FontSize.s14,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            if (_searchController.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                  setState(() => _results = []);
                },
                child: Icon(Icons.close, color: AppColors.grey, size: 18.sp),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentLocationOption() {
    return InkWell(
      onTap: () => Navigator.pop(context, AppStrings.yourCurrentLocation),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Insets.s16,
          vertical: Insets.s12,
        ),
        child: Row(
          children: [
            Container(
              width: 26.w,
              height: 26.w,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.my_location_rounded,
                color: AppColors.white,
                size: 14.sp,
              ),
            ),
            SizedBox(width: Insets.s12),
            Text(
              AppStrings.yourCurrentLocation,
              style: getMediumStyle(
                color: AppColors.primary,
                fontSize: FontSize.s14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChooseOnMapOption() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.mapSelection,
          arguments: MapSelectionArgs(title: widget.args.title),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Insets.s16,
          vertical: Insets.s12,
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: AppColors.primary,
              size: 24.sp,
            ),
            SizedBox(width: Insets.s12),
            Text(
              'حدد الموقع علي الخريطة',
              style: getMediumStyle(
                color: AppColors.black,
                fontSize: FontSize.s14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    final items = _results.isEmpty ? _allLocations : _results;
    return ListView.separated(
      padding: EdgeInsets.only(top: 4.h),
      itemCount: items.length,
      separatorBuilder: (_, __) =>
          const Divider(color: AppColors.divider, height: 1),
      itemBuilder: (context, index) {
        final loc = items[index];
        return InkWell(
          onTap: () => Navigator.pop(context, loc.title),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Insets.s16,
              vertical: Insets.s12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.title,
                        style: getMediumStyle(
                          color: AppColors.black,
                          fontSize: FontSize.s14,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        loc.subtitle,
                        style: getRegularStyle(
                          color: AppColors.grey,
                          fontSize: FontSize.s12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: Insets.s12),
                Icon(
                  Icons.north_west_rounded,
                  color: AppColors.grey,
                  size: 20.sp,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LocationItem {
  final String title;
  final String subtitle;
  const _LocationItem({required this.title, required this.subtitle});
}
