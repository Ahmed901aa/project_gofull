import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/strings_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/home/presentation/screens/home_screen.dart';
import 'package:project_gofull/features/orders/presentation/screens/orders_screen.dart';
import 'package:project_gofull/features/profile/presentation/screens/profile_screen.dart';
import '../widgets/nav_item.dart';

class BottomNavShell extends StatefulWidget {
  BottomNavShell({Key? key}) : super(key: key ?? shellKey);

  static final shellKey = GlobalKey<_BottomNavShellState>();

  @override
  State<BottomNavShell> createState() => _BottomNavShellState();
}

class _BottomNavShellState extends State<BottomNavShell> {
  int _currentIndex = 0;

  void switchTo(int index) => setState(() => _currentIndex = index);

  final List<Widget> _screens = const [
    HomeScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: EdgeInsets.only(top: 12.h, left: 32.w, right: 32.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NavItem(icon: Icons.home_rounded, label: AppStrings.home, index: 0, currentIndex: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
                NavItem(icon: Icons.receipt_long_rounded, label: AppStrings.myOrders, index: 1, currentIndex: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
                NavItem(icon: Icons.person_outline_rounded, label: AppStrings.myAccount, index: 2, currentIndex: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
