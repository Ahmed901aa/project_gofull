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

class _LocationSearchScreenState extends State<LocationSearchScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // Mock data
  final List<_LocationItem> _recentLocations = const [
    _LocationItem(title: 'شارع التحلية، طرابلس', subtitle: 'طرابلس، ليبيا'),
    _LocationItem(title: 'حي الأندلس، طرابلس', subtitle: 'طرابلس، ليبيا'),
    _LocationItem(title: 'سوق الجمعة', subtitle: 'طرابلس، ليبيا'),
    _LocationItem(title: 'جامعة طرابلس', subtitle: 'طرابلس، ليبيا'),
    _LocationItem(title: 'مطار معيتيقة الدولي', subtitle: 'طرابلس، ليبيا'),
  ];

  final List<_LocationItem> _favoriteLocations = const [
    _LocationItem(title: 'المنزل', subtitle: 'شارع التحلية، طرابلس'),
    _LocationItem(title: 'العمل', subtitle: 'حي الأندلس، طرابلس'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            _buildAppBar(),

            // Search bar
            _buildSearchBar(),
            SizedBox(height: Sizes.s8),

            // Current location option
            if (widget.args.showCurrentLocation) ...[
              _buildCurrentLocationOption(),
              const Divider(color: AppColors.divider, height: 1),
            ],

            // Choose on map option
            _buildChooseOnMapOption(),
            const Divider(color: AppColors.divider, height: 1),

            // Tabs
            _buildTabs(),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildLocationList(_favoriteLocations),
                  _buildLocationList(_recentLocations),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Insets.s16,
        vertical: Insets.s12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.args.title,
              style: getBoldStyle(
                color: AppColors.black,
                fontSize: FontSize.s18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
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
                size: 20.sp,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Insets.s12,
          vertical: Insets.s4,
        ),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(AppRadius.s12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              color: AppColors.grey,
              size: 22.sp,
            ),
            SizedBox(width: Insets.s8),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: getRegularStyle(
                  color: AppColors.black,
                  fontSize: FontSize.s14,
                ),
                decoration: InputDecoration(
                  hintText: AppStrings.searchLocation,
                  hintStyle: getRegularStyle(
                    color: AppColors.grey,
                    fontSize: FontSize.s14,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: Insets.s8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentLocationOption() {
    return InkWell(
      onTap: () {
        // Return current location
        Navigator.pop(context, 'موقعك الحالي');
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Insets.s16,
          vertical: Insets.s12,
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.my_location_rounded,
                color: AppColors.primary,
                size: 20.sp,
              ),
            ),
            SizedBox(width: Insets.s12),
            Text(
              AppStrings.useCurrentLocation,
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
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.map_rounded,
                color: AppColors.primary,
                size: 20.sp,
              ),
            ),
            SizedBox(width: Insets.s12),
            Text(
              AppStrings.chooseOnMap,
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

  Widget _buildTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.grey,
        indicatorColor: AppColors.primary,
        indicatorWeight: 2.5,
        labelStyle: getSemiBoldStyle(
          color: AppColors.primary,
          fontSize: FontSize.s14,
        ),
        unselectedLabelStyle: getRegularStyle(
          color: AppColors.grey,
          fontSize: FontSize.s14,
        ),
        tabs: const [
          Tab(text: AppStrings.favorites),
          Tab(text: AppStrings.recentLocations),
        ],
      ),
    );
  }

  Widget _buildLocationList(List<_LocationItem> locations) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: Insets.s8),
      itemCount: locations.length,
      separatorBuilder: (_, __) => const Divider(
        color: AppColors.divider,
        height: 1,
        indent: 68,
      ),
      itemBuilder: (context, index) {
        final location = locations[index];
        return InkWell(
          onTap: () {
            Navigator.pop(context, location.title);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Insets.s16,
              vertical: Insets.s12,
            ),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: AppColors.grey,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: Insets.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location.title,
                        style: getMediumStyle(
                          color: AppColors.black,
                          fontSize: FontSize.s14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        location.subtitle,
                        style: getRegularStyle(
                          color: AppColors.grey,
                          fontSize: FontSize.s12,
                        ),
                      ),
                    ],
                  ),
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
