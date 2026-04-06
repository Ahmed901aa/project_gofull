import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/provider/domain/entities/provider_profile_entity.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_bloc.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_event.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_state.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProviderBloc>()..add(const LoadProfileEvent()),
      child: Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocBuilder<ProviderBloc, ProviderState>(
                builder: (context, state) {
                  if (state is ProviderLoading) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                  }
                  final profile = state is ProfileLoaded ? state.profile : null;
                  return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(Insets.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ProfileCard(profile: profile),
                    SizedBox(height: Insets.s16),
                    _InfoBoxesRow(profile: profile),
                    SizedBox(height: Insets.s20),
                    _VehicleSection(profile: profile),
                    SizedBox(height: Insets.s20),
                    _DocumentsSection(),
                    SizedBox(height: Insets.s24),
                  ],
                ),
              );
                },
            ),
          ],
        ),
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
              padding: EdgeInsets.fromLTRB(
                  Insets.s16, Insets.s12, Insets.s16, Insets.s12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_rounded,
                        size: 24.sp, color: const Color(0xFF0E0E0E)),
                  ),
                  Expanded(
                    child: Text(
                      'الملف الشخصي',
                      style: getBoldStyle(
                          color: const Color(0xFF0E0E0E),
                          fontSize: FontSize.s20),
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
}

// ── Profile Card ─────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final ProviderProfileEntity? profile;
  const _ProfileCard({this.profile});
  @override
  Widget build(BuildContext context) {
    final name = profile?.userName ?? 'السائق';
    final id = profile != null ? 'ID-${profile!.id}' : '';
    final role = profile?.isTowingProvider == true ? 'سائق ونش' : 'سائق إمداد وقود';
    final isOnline = profile?.isAvailable ?? false;
    return Container(
      padding: EdgeInsets.all(Insets.s16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.s24),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E6),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 2),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.person_rounded,
                size: 40.sp, color: AppColors.primary),
          ),
          SizedBox(width: Insets.s12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: getBoldStyle(
                      color: AppColors.white, fontSize: FontSize.s18),
                ),
                SizedBox(height: 2.h),
                Text(
                  id,
                  style: getRegularStyle(
                      color: AppColors.white.withValues(alpha: 0.7),
                      fontSize: FontSize.s12),
                ),
                SizedBox(height: 4.h),
                Text(
                  role,
                  style: getRegularStyle(
                      color: AppColors.white, fontSize: FontSize.s14),
                ),
                SizedBox(height: Insets.s8),
                // Status badge
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Insets.s12, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppRadius.s16),
                  ),
                  child: Text(
                    isOnline ? 'نشط' : 'غير نشط',
                    style: getMediumStyle(
                        color: AppColors.gold, fontSize: FontSize.s12),
                  ),
                ),
              ],
            ),
          ),
          // Edit icon
          GestureDetector(
            onTap: () {
              // replace with navigation to edit profile
            },
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child:
                  Icon(Icons.edit_rounded, size: 18.sp, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Info Boxes ───────────────────────────────────────────

class _InfoBoxesRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _infoBox('التقييم', '4.8', Icons.star_rounded)),
        SizedBox(width: Insets.s12),
        Expanded(
            child: _infoBox(
                'تاريخ الانضمام', 'منذ 2024', Icons.calendar_today_rounded)),
      ],
    );
  }

  Widget _infoBox(String label, String value, IconData icon) => Container(
        padding: EdgeInsets.all(Insets.s16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: AppColors.neutral500),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24.sp, color: AppColors.gold),
            SizedBox(height: Insets.s8),
            Text(
              value,
              style: getBoldStyle(
                  color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: getRegularStyle(
                  color: AppColors.grey, fontSize: FontSize.s12),
            ),
          ],
        ),
      );
}

// ── Salary Section ───────────────────────────────────────

class _SalarySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'المرتب',
          style: getBoldStyle(
              color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
        ),
        SizedBox(height: Insets.s8),
        Container(
          padding: EdgeInsets.all(Insets.s16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: AppColors.neutral500),
          ),
          child: Row(
            children: [
              Icon(Icons.account_balance_wallet_rounded,
                  size: 24.sp, color: AppColors.primary),
              SizedBox(width: Insets.s12),
              Text(
                'مرتب ثابت:',
                style: getRegularStyle(
                    color: AppColors.darkGrey, fontSize: FontSize.s14),
              ),
              SizedBox(width: 4.w),
              Text(
                '1500 د.ك',
                style: getBoldStyle(
                    color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Vehicle Section ──────────────────────────────────────

class _VehicleSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'المعهدة',
          style: getBoldStyle(
              color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
        ),
        SizedBox(height: Insets.s8),
        Row(
          children: [
            Expanded(child: _vehicleBadge('نوع الونش', 'ونش هيدروليك')),
            SizedBox(width: Insets.s8),
            Expanded(child: _vehicleBadge('رقم الوحدة', 'أ ب م - 3541')),
          ],
        ),
        SizedBox(height: Insets.s12),
        // Vehicle image placeholder
        Container(
          height: 180.h,
          decoration: BoxDecoration(
            color: AppColors.neutral400,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: AppColors.neutral500),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.fire_truck_rounded,
                    size: 56.sp, color: AppColors.neutral600),
                SizedBox(height: Insets.s8),
                Text(
                  'صورة المعهدة',
                  style: getRegularStyle(
                      color: AppColors.neutral800, fontSize: FontSize.s14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _vehicleBadge(String label, String value) => Container(
        padding: EdgeInsets.all(Insets.s12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.s16),
          border: Border.all(color: AppColors.neutral500),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: getRegularStyle(
                  color: AppColors.grey, fontSize: FontSize.s12),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: getSemiBoldStyle(
                  color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
            ),
          ],
        ),
      );
}

// ── Documents Section ────────────────────────────────────

enum _DocStatus { accepted, underReview, required_ }

class _DocItem {
  final String name;
  final _DocStatus status;
  const _DocItem({required this.name, required this.status});
}

const _documents = [
  _DocItem(name: 'الرقم القومي', status: _DocStatus.underReview),
  _DocItem(name: 'رخصة القيادة', status: _DocStatus.accepted),
  _DocItem(name: 'الرقم القومي', status: _DocStatus.required_),
];

class _DocumentsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'الوثائق',
          style: getBoldStyle(
              color: const Color(0xFF0E0E0E), fontSize: FontSize.s16),
        ),
        SizedBox(height: Insets.s8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.s16),
            border: Border.all(color: AppColors.neutral500),
          ),
          child: Column(
            children: _documents.asMap().entries.map((entry) {
              final doc = entry.value;
              final isLast = entry.key == _documents.length - 1;
              return Column(
                children: [
                  _docRow(doc),
                  if (!isLast)
                    Divider(
                        height: 1,
                        color: AppColors.neutral500,
                        indent: Insets.s16,
                        endIndent: Insets.s16),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _docRow(_DocItem doc) {
    Color statusBg;
    Color statusFg;
    String statusLabel;
    String actionLabel;
    bool showUpload = false;

    switch (doc.status) {
      case _DocStatus.accepted:
        statusBg = AppColors.success.withValues(alpha: 0.1);
        statusFg = AppColors.success;
        statusLabel = 'مقبولة';
        actionLabel = 'عرض';
      case _DocStatus.underReview:
        statusBg = AppColors.gold.withValues(alpha: 0.1);
        statusFg = AppColors.gold;
        statusLabel = 'قيد المراجعة';
        actionLabel = 'عرض';
      case _DocStatus.required_:
        statusBg = AppColors.error.withValues(alpha: 0.1);
        statusFg = AppColors.error;
        statusLabel = 'مطلوب';
        actionLabel = 'رفع الملف';
        showUpload = true;
    }

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s12),
      child: Row(
        children: [
          // Doc icon
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: AppColors.neutral400,
              borderRadius: BorderRadius.circular(AppRadius.s8),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.description_outlined,
                size: 20.sp, color: AppColors.darkGrey),
          ),
          SizedBox(width: Insets.s12),
          // Name + status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.name,
                  style: getMediumStyle(
                      color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Insets.s8, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(AppRadius.s8),
                  ),
                  child: Text(
                    statusLabel,
                    style: getMediumStyle(
                        color: statusFg, fontSize: FontSize.s12),
                  ),
                ),
              ],
            ),
          ),
          // Action button
          GestureDetector(
            onTap: () {
              // replace with view / upload action
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Insets.s12, vertical: Insets.s4),
              decoration: BoxDecoration(
                color: showUpload ? AppColors.primary : AppColors.neutral400,
                borderRadius: BorderRadius.circular(AppRadius.s8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showUpload) ...[
                    Icon(Icons.upload_file_rounded,
                        size: 14.sp, color: AppColors.white),
                    SizedBox(width: 4.w),
                  ],
                  Text(
                    actionLabel,
                    style: getMediumStyle(
                      color: showUpload ? AppColors.white : AppColors.primary,
                      fontSize: FontSize.s12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
