import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/profile/presentation/widgets/coupon_card.dart';
import 'package:project_gofull/features/profile/presentation/widgets/discount_tabs.dart';
import 'package:project_gofull/features/profile/presentation/widgets/expired_coupon_card.dart';

// replace with API data later
const _mockCoupons = [
  {'title': 'خصم 50 ج.م', 'expiry': 'ينتهي 3 يناير 2025'},
  {'title': 'خصم 50 ج.م', 'expiry': 'ينتهي 3 يناير 2025'},
];

class DiscountCodesScreen extends StatefulWidget {
  const DiscountCodesScreen({super.key});
  @override
  State<DiscountCodesScreen> createState() => _DiscountCodesScreenState();
}

class _DiscountCodesScreenState extends State<DiscountCodesScreen> {
  int _selectedTab = 0;
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: Insets.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: Insets.s16),
                    _buildInputSection(),
                    SizedBox(height: Insets.s16),
                    _buildActivateButton(),
                    SizedBox(height: Insets.s16),
                    DiscountTabs(selectedTab: _selectedTab, onTabChanged: (i) => setState(() => _selectedTab = i)),
                    SizedBox(height: Insets.s16),
                    if (_selectedTab == 0)
                      ..._mockCoupons.map((c) => Padding(
                            padding: EdgeInsets.only(bottom: Sizes.s12),
                            child: CouponCard(title: c['title']!, expiry: c['expiry']!),
                          )),
                    if (_selectedTab == 1)
                      ..._mockCoupons.map((c) => Padding(
                            padding: EdgeInsets.only(bottom: Sizes.s12),
                            child: ExpiredCouponCard(title: c['title']!, expiry: 'انتهي 3 يناير 2025'),
                          )),
                    SizedBox(height: Sizes.s16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
        color: AppColors.white,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Padding(
              padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
              child: Row(
                children: [
                  GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.arrow_back_rounded, size: 24.sp, color: const Color(0xFF0E0E0E))),
                  Expanded(child: Text('أكواد الخصم', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20), textAlign: TextAlign.center)),
                  SizedBox(width: 24.sp),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF5F5F5)),
          ],
        ),
      );

  Widget _buildInputSection() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('عندك كود خصم؟', style: getMediumStyle(color: const Color(0xFF121212), fontSize: FontSize.s16).copyWith(height: 1.4)),
          SizedBox(height: Sizes.s8),
          Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: Insets.s16),
            decoration: BoxDecoration(color: AppColors.neutral200, borderRadius: BorderRadius.circular(AppRadius.s16), border: Border.all(color: AppColors.neutral500)),
            alignment: Alignment.centerRight,
            child: TextField(
              controller: _codeController,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(hintText: 'أدخل كود الخصم..', hintStyle: getRegularStyle(color: const Color(0xFFAAAAAB), fontSize: FontSize.s14), border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
              style: getRegularStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
            ),
          ),
        ],
      );

  Widget _buildActivateButton() => SizedBox(
        height: 48.h,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF004B3B), foregroundColor: AppColors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)), elevation: 0),
          child: Text('تفعيل', style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s16).copyWith(height: 1.6)),
        ),
      );
}
