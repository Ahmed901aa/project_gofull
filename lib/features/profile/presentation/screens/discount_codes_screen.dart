import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';

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
                    _buildTabs(),
                    SizedBox(height: Insets.s16),
                    if (_selectedTab == 0) _buildCouponsList(),
                    if (_selectedTab == 1) _buildPreviousCodes(),
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
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_forward_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
                  ),
                  Expanded(
                    child: Text(
                      'أكواد الخصم',
                      style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20),
                      textAlign: TextAlign.center,
                    ),
                  ),
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
          Text(
            'عندك كود خصم؟',
            style: getMediumStyle(color: const Color(0xFF121212), fontSize: FontSize.s16).copyWith(height: 1.4),
          ),
          SizedBox(height: Sizes.s8),
          Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: Insets.s16),
            decoration: BoxDecoration(
              color: AppColors.neutral200,
              borderRadius: BorderRadius.circular(AppRadius.s16),
              border: Border.all(color: AppColors.neutral500),
            ),
            alignment: Alignment.centerRight,
            child: TextField(
              controller: _codeController,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: 'أدخل كود الخصم..',
                hintStyle: getRegularStyle(color: const Color(0xFFAAAAAB), fontSize: FontSize.s14),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
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
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF004B3B),
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)),
            elevation: 0,
          ),
          child: Text(
            'تفعيل',
            style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s16).copyWith(height: 1.6),
          ),
        ),
      );

  Widget _buildTabs() => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTab = 0),
                  child: IntrinsicWidth(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'قائمة التوفير',
                          style: getRegularStyle(
                            color: const Color(0xFF0E0E0E),
                            fontSize: FontSize.s18,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          height: 2.h,
                          decoration: BoxDecoration(
                            color: _selectedTab == 0 ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(AppRadius.s24),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTab = 1),
                  child: IntrinsicWidth(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'أكواد سابقة',
                          style: getRegularStyle(
                            color: const Color(0xFF0E0E0E),
                            fontSize: FontSize.s18,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          height: 2.h,
                          decoration: BoxDecoration(
                            color: _selectedTab == 1 ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(AppRadius.s24),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(height: 1, color: AppColors.neutral600),
        ],
      );

  Widget _buildCouponsList() => Column(
        children: _mockCoupons
            .map((c) => Padding(
                  padding: EdgeInsets.only(bottom: Sizes.s12),
                  child: _CouponCard(title: c['title']!, expiry: c['expiry']!),
                ))
            .toList(),
      );

  Widget _buildPreviousCodes() => Column(
        children: _mockCoupons
            .map((c) => Padding(
                  padding: EdgeInsets.only(bottom: Sizes.s12),
                  child: _ExpiredCouponCard(title: c['title']!, expiry: 'انتهي 3 يناير 2025'),
                ))
            .toList(),
      );
}

class _CouponCard extends StatelessWidget {
  final String title;
  final String expiry;
  const _CouponCard({required this.title, required this.expiry});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 79.h,
      padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
      decoration: BoxDecoration(
        color: AppColors.neutral400,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: AppColors.dots,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(Icons.local_offer_outlined, size: 16.sp, color: AppColors.primary),
          ),
          SizedBox(width: 4.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
              ),
              Text(
                expiry,
                style: getRegularStyle(color: const Color(0xFF121212), fontSize: FontSize.s16).copyWith(
                  fontWeight: FontWeight.w100,
                  height: 1.6,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            height: 32.h,
            padding: EdgeInsets.symmetric(horizontal: Insets.s16),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppRadius.s24),
            ),
            alignment: Alignment.center,
            child: Text(
              'إستخدام',
              style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s14),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpiredCouponCard extends StatelessWidget {
  final String title;
  final String expiry;
  const _ExpiredCouponCard({required this.title, required this.expiry});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 79.h,
      padding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
      decoration: BoxDecoration(
        color: AppColors.neutral400,
        borderRadius: BorderRadius.circular(AppRadius.s16),
        border: Border.all(color: AppColors.neutral500, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: const BoxDecoration(
              color: AppColors.neutral500,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(Icons.local_offer_outlined, size: 16.sp, color: AppColors.neutral900),
          ),
          SizedBox(width: 4.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
              ),
              Text(
                expiry,
                style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s16).copyWith(
                  fontWeight: FontWeight.w100,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
