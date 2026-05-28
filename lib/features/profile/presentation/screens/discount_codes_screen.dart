import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/profile/presentation/widgets/coupon_card.dart';
import 'package:project_gofull/features/profile/presentation/widgets/discount_code_input.dart';
import 'package:project_gofull/features/profile/presentation/widgets/discount_tabs.dart';
import 'package:project_gofull/features/profile/presentation/widgets/expired_coupon_card.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

// TODO: Connect to coupons API when backend endpoint is available
const List<Map<String, String>> _activeCoupons = [];
const List<Map<String, String>> _expiredCoupons = [];

class DiscountCodesScreen extends StatefulWidget {
  const DiscountCodesScreen({super.key});
  @override
  State<DiscountCodesScreen> createState() => _DiscountCodesScreenState();
}

class _DiscountCodesScreenState extends State<DiscountCodesScreen> {
  int _selectedTab = 0;
  final _codeController = TextEditingController();

  @override
  void dispose() { _codeController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: Column(children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: Insets.s16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                SizedBox(height: Insets.s16),
                DiscountCodeInput(controller: _codeController),
                SizedBox(height: Insets.s16),
                DiscountTabs(selectedTab: _selectedTab, onTabChanged: (i) => setState(() => _selectedTab = i)),
                SizedBox(height: Insets.s16),
                if (_selectedTab == 0 && _activeCoupons.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: Insets.s24),
                    child: Center(child: Text(l10n.noActiveCoupons, style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s14))),
                  ),
                if (_selectedTab == 0)
                  ..._activeCoupons.map((c) => Padding(padding: EdgeInsets.only(bottom: Sizes.s12), child: CouponCard(title: c['title']!, expiry: c['expiry']!))),
                if (_selectedTab == 1 && _expiredCoupons.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: Insets.s24),
                    child: Center(child: Text(l10n.noExpiredCoupons, style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s14))),
                  ),
                if (_selectedTab == 1)
                  ..._expiredCoupons.map((c) => Padding(padding: EdgeInsets.only(bottom: Sizes.s12), child: ExpiredCouponCard(title: c['title']!, expiry: c['expiry']!))),
                SizedBox(height: Sizes.s16),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
        color: AppColors.white,
        child: Column(children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
            child: Row(children: [
              GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.arrow_back_rounded, size: 24.sp, color: const Color(0xFF0E0E0E))),
              Expanded(child: Text(l10n.discountCodes, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20), textAlign: TextAlign.center)),
              SizedBox(width: 24.sp),
            ]),
          ),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
        ]),
      );
}
