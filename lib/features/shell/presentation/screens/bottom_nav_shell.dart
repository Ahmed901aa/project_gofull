import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/widgets/rating_bottom_sheet.dart';
import 'package:project_gofull/features/home/presentation/screens/home_screen.dart';
import 'package:project_gofull/features/orders/presentation/screens/orders_screen.dart';
import 'package:project_gofull/features/profile/presentation/screens/profile_screen.dart';
import 'package:project_gofull/features/profile/presentation/screens/support_screen.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
import '../widgets/nav_item.dart';

class BottomNavShell extends StatefulWidget {
  BottomNavShell({Key? key}) : super(key: key ?? shellKey);

  static final shellKey = GlobalKey<_BottomNavShellState>();

  /// Call this when a new order is created — saves the order ID so we know
  /// the customer had an active order when they left.
  static Future<void> markOrderActive(int orderId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('active_order_id', orderId);
    await prefs.setBool('completed_in_app', false);
  }

  /// Call this when the customer sees the completion screen inside the app.
  /// This means they DON'T need the rating popup — they'll rate normally.
  static Future<void> markCompletedInApp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('completed_in_app', true);
    await prefs.remove('active_order_id');
  }

  @override
  State<BottomNavShell> createState() => _BottomNavShellState();
}

class _BottomNavShellState extends State<BottomNavShell>
    with WidgetsBindingObserver {
  int _currentIndex = 0;
  Key _ordersKey = UniqueKey();

  late final RequestBloc _ratingBloc;
  bool _ratingSheetShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _ratingBloc = sl<RequestBloc>();
    // On first app open, check if an order completed while the user was away
    _checkIfCompletedWhileAway();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // ONLY check when returning from background — not on every state change
    if (state == AppLifecycleState.resumed) {
      _checkIfCompletedWhileAway();
    }
  }

  Future<void> _checkIfCompletedWhileAway() async {
    if (_ratingSheetShown) return;

    final prefs = await SharedPreferences.getInstance();
    final activeOrderId = prefs.getInt('active_order_id');
    final completedInApp = prefs.getBool('completed_in_app') ?? false;
    final dismissed =
        prefs.getBool('rating_dismissed_$activeOrderId') ?? false;

    // Only check if:
    // 1. There was an active order saved
    // 2. The customer was NOT in the app when it completed
    // 3. They haven't already dismissed this rating popup
    if (activeOrderId == null || completedInApp || dismissed) return;

    // Ask the backend if there's an unrated completed order
    _ratingBloc.add(const CheckUnratedOrderEvent());
  }

  void _onRatingState(BuildContext context, RequestState state) async {
    if (state is! UnratedOrderFound || _ratingSheetShown) return;

    final order = state.request;
    final prefs = await SharedPreferences.getInstance();
    final activeOrderId = prefs.getInt('active_order_id');

    // Extra safety: only show for the order that was active when user left
    if (activeOrderId != null && activeOrderId != order.id) return;

    // Fuel orders use inline rating on fuel_complete_screen — skip bottom sheet
    if (order.isFuelDelivery) return;

    _ratingSheetShown = true;
    // Delay so the home screen is visible first
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      showRatingBottomSheet(context, order).then((rated) {
        _ratingSheetShown = false;
        if (rated) {
          // Rated successfully — clear everything
          prefs.remove('active_order_id');
          prefs.remove('completed_in_app');
        } else {
          // Dismissed — don't show again
          prefs.setBool('rating_dismissed_${order.id}', true);
        }
      });
    });
  }

  void switchTo(int index) {
    if (index == 1) _ordersKey = UniqueKey();
    setState(() => _currentIndex = index);
  }

  List<Widget> get _screens => [
        const HomeScreen(),
        KeyedSubtree(key: _ordersKey, child: const OrdersScreen()),
        const SupportScreen(showBack: false),
        const ProfileScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _ratingBloc,
      child: BlocListener<RequestBloc, RequestState>(
        listener: _onRatingState,
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: IndexedStack(index: _currentIndex, children: _screens),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: AppColors.scaffoldBg,
              border: Border(top: BorderSide(color: Color(0xFFF4F5F6))),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding:
                    EdgeInsetsDirectional.only(top: 12.h, start: 24.w, end: 24.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    NavItem(
                      icon: Icons.home_rounded,
                      label: S.of(context).home,
                      index: 0,
                      currentIndex: _currentIndex,
                      onTap: switchTo,
                    ),
                    NavItem(
                      icon: Icons.receipt_long_rounded,
                      label: S.of(context).myOrders,
                      index: 1,
                      currentIndex: _currentIndex,
                      onTap: switchTo,
                    ),
                    NavItem(
                      icon: Icons.headset_mic_outlined,
                      label: S.of(context).support,
                      index: 2,
                      currentIndex: _currentIndex,
                      onTap: switchTo,
                    ),
                    NavItem(
                      icon: Icons.person_outline_rounded,
                      label: S.of(context).myAccount,
                      index: 3,
                      currentIndex: _currentIndex,
                      onTap: switchTo,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
