import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/core/utils/route_args.dart';
import 'package:project_gofull/core/widgets/provider_info_card.dart';
import 'package:project_gofull/core/widgets/service_location_card.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';
import 'package:project_gofull/features/orders/models/order_data.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
import 'package:project_gofull/features/towing/presentation/widgets/detail_chip.dart';
import 'package:project_gofull/features/towing/presentation/widgets/trip_payment_section.dart';

class TowingTripDetailsScreen extends StatefulWidget {
  final TripDetailsArgs? args;
  const TowingTripDetailsScreen({super.key, this.args});

  @override
  State<TowingTripDetailsScreen> createState() =>
      _TowingTripDetailsScreenState();
}

class _TowingTripDetailsScreenState extends State<TowingTripDetailsScreen> {
  late final RequestBloc _requestBloc;
  ServiceRequestEntity? _request;

  // Rating state
  bool _showRating = false;
  int _rating = 0;
  final _notesController = TextEditingController();
  static const int _maxNoteLength = 80;
  bool _ratingSubmitted = false;
  final _scrollController = ScrollController();
  final _ratingKey = GlobalKey();

  bool get _canRate =>
      widget.args != null &&
      widget.args!.status == OrderStatus.completed &&
      !widget.args!.isRated;

  bool get _alreadyRated =>
      widget.args != null &&
      widget.args!.status == OrderStatus.completed &&
      widget.args!.isRated;

  @override
  void initState() {
    super.initState();
    _requestBloc = sl<RequestBloc>();
    final id = int.tryParse(widget.args?.orderId ?? '');
    if (id != null) _requestBloc.add(LoadRequestDetailsEvent(id));
  }

  @override
  void dispose() {
    _notesController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onTapRating() {
    setState(() => _showRating = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_ratingKey.currentContext != null) {
        Scrollable.ensureVisible(
          _ratingKey.currentContext!,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _submitRating() {
    final id = int.tryParse(widget.args?.orderId ?? '');
    if (id != null && _rating > 0) {
      sl<RequestBloc>().add(RateProviderEvent(
        requestId: id,
        rating: _rating,
        comment:
            _notesController.text.isNotEmpty ? _notesController.text : null,
      ));
    }
    setState(() => _ratingSubmitted = true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _requestBloc,
      child: BlocListener<RequestBloc, RequestState>(
        listener: (context, state) {
          if (state is RequestDetailsLoaded) {
            setState(() => _request = state.request);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBg,
          body: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _request == null
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primary))
                    : SingleChildScrollView(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.all(Insets.s16),
                        child: _buildBody(context, _request!),
                      ),
              ),
              _buildBottomButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ServiceRequestEntity req) {
    final cur = context.read<AppConfigBloc>().state.currency;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: Sizes.s8),
        _section(
          'مسار الرحلة',
          Column(children: [
            ServiceLocationCard(
                topLabel: 'نقطة الانطلاق',
                bottomLabel: req.driverAddress ?? '—'),
            SizedBox(height: Sizes.s8),
            ServiceLocationCard(
                topLabel: 'وجهة التوصيل',
                bottomLabel: req.destinationAddress ?? '—'),
          ]),
        ),
        SizedBox(height: Insets.s16),
        _section(
          'تفاصيل السيارة',
          Row(children: [
            if (req.carType != null)
              DetailChip(label: 'نوع السيارة: ${req.carType}'),
            if (req.carType != null && req.plateNumber != null)
              SizedBox(width: Sizes.s8),
            if (req.plateNumber != null)
              DetailChip(label: 'رقم اللوحة: ${req.plateNumber}'),
          ]),
        ),
        SizedBox(height: Insets.s16),
        _section(
          'تفاصيل مزود الخدمة',
          ProviderInfoCard.fromRequest(req),
        ),
        SizedBox(height: Insets.s16),
        _section(
          'ملخص الدفع',
          TripPaymentSection(
            subtotal:
                req.subtotal != null ? '${req.subtotal} $cur' : '— $cur',
            serviceFee: req.serviceFee != null
                ? '${req.serviceFee} $cur'
                : '— $cur',
            total: req.total != null ? '${req.total} $cur' : '— $cur',
          ),
        ),
        SizedBox(height: Insets.s16),

        // ── Already rated badge ──
        if (_alreadyRated && !_ratingSubmitted)
          Container(
            padding: EdgeInsets.all(Insets.s16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.s16),
              border: Border.all(color: const Color(0xFFEFF0F1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_rounded,
                    size: 20.sp, color: AppColors.primary),
                SizedBox(width: 8.w),
                Text('تم تقييم هذه الرحلة',
                    style: getMediumStyle(
                        color: AppColors.primary,
                        fontSize: FontSize.s14)),
              ],
            ),
          ),

        // ── Inline Rating Section ──
        if (_showRating) ...[
          Container(
            key: _ratingKey,
            padding: EdgeInsets.all(Insets.s16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.s16),
              border: Border.all(color: const Color(0xFFEFF0F1)),
            ),
            child: _ratingSubmitted
                ? _buildRatingSuccess()
                : _buildRatingForm(),
          ),
          SizedBox(height: Insets.s16),
        ],

        SizedBox(height: Insets.s16),
      ],
    );
  }

  // ── Rating Form ─────────────────────────────────────────────
  Widget _buildRatingForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('كيف كانت تجربتك؟',
            style: getBoldStyle(
                color: const Color(0xFF0E0E0E), fontSize: FontSize.s18)),
        SizedBox(height: 2.h),
        Text(
          'ملاحظاتك تساعدنا في تحسين جودة خدماتنا وتطوير أداء السائقين.',
          style: getRegularStyle(
              color: AppColors.neutral900, fontSize: FontSize.s14),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: Insets.s16),
        // Stars (RTL — right to left)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            final star = 5 - i;
            return GestureDetector(
              onTap: () => setState(() => _rating = star),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Icon(
                  _rating >= star
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  size: 40.sp,
                  color: const Color(0xFFFFB800),
                ),
              ),
            );
          }),
        ),
        // Notes field (appears after choosing a rating)
        if (_rating > 0) ...[
          SizedBox(height: Insets.s16),
          Align(
            alignment: Alignment.centerRight,
            child: Text('أضف ملاحظاتك',
                style: getBoldStyle(
                    color: const Color(0xFF0E0E0E),
                    fontSize: FontSize.s14)),
          ),
          SizedBox(height: Insets.s8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.scaffoldBg,
              borderRadius: BorderRadius.circular(AppRadius.s16),
              border: Border.all(color: AppColors.neutral500),
            ),
            child: TextField(
              controller: _notesController,
              maxLength: _maxNoteLength,
              maxLines: 3,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: getRegularStyle(
                  color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
              decoration: InputDecoration(
                hintText: 'اكتب هنا أي تفاصيل إضافية تود مشاركتها...',
                hintStyle: getRegularStyle(
                    color: AppColors.neutral900, fontSize: FontSize.s14),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: Insets.s16, vertical: Insets.s8),
                border: InputBorder.none,
                counterText: '',
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          SizedBox(height: 4.h),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.s8),
              child: Text(
                '${_notesController.text.length}/$_maxNoteLength',
                style: getMediumStyle(
                    color: AppColors.neutral900, fontSize: FontSize.s12),
                textDirection: TextDirection.ltr,
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ── Rating Success ─────────────────────────────────────────
  Widget _buildRatingSuccess() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle_rounded,
            size: 48.sp, color: AppColors.primary),
        SizedBox(height: Insets.s8),
        Text('شكراً لتقييمك!',
            style: getBoldStyle(
                color: const Color(0xFF0E0E0E), fontSize: FontSize.s18)),
        SizedBox(height: 4.h),
        Text(
          'تم إرسال تقييمك بنجاح. شكراً لمساعدتنا في تحسين خدماتنا.',
          style: getRegularStyle(
              color: AppColors.neutral800, fontSize: FontSize.s14),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: Insets.s8),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (i) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Icon(
                  _rating >= (i + 1)
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  size: 28.sp,
                  color: const Color(0xFFFFB800),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _section(String title, Widget content) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title,
              style: getBoldStyle(
                  color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
              textAlign: TextAlign.right),
          SizedBox(height: Insets.s8),
          content,
        ],
      );

  Widget _buildHeader(BuildContext context) => Container(
        color: AppColors.white,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  Insets.s16, Insets.s12, Insets.s16, Insets.s12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back_ios_new_rounded,
                          size: 20.sp, color: const Color(0xFF0E0E0E))),
                  Text('تفاصيل الرحلة',
                      style: getBoldStyle(
                          color: const Color(0xFF0E0E0E),
                          fontSize: FontSize.s20)),
                  SizedBox(width: 24.sp),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF5F5F5)),
          ],
        ),
      );

  Widget _buildBottomButton(BuildContext context) {
    // After rating submitted → go home
    if (_ratingSubmitted) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFFCCCCCC).withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, -2))
          ],
        ),
        padding:
            EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s16),
        child: SizedBox(
          height: 48.h,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, Routes.home, (route) => false),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.s16)),
              elevation: 0,
            ),
            child: Text('العودة للرئيسية',
                style: getBoldStyle(
                    color: AppColors.white, fontSize: FontSize.s16)),
          ),
        ),
      );
    }

    // Rating form visible → submit button
    if (_showRating) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFFCCCCCC).withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, -2))
          ],
        ),
        padding:
            EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 48.h,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _rating == 0 ? null : _submitRating,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor:
                      AppColors.primary.withValues(alpha: 0.4),
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.s16)),
                  elevation: 0,
                ),
                child: Text('إرسال التقييم',
                    style: getBoldStyle(
                        color: AppColors.white, fontSize: FontSize.s16)),
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              height: 40.h,
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, Routes.home, (route) => false),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.s16)),
                ),
                child: Text('تخطي',
                    style: getRegularStyle(
                        color: AppColors.grey, fontSize: FontSize.s14)),
              ),
            ),
          ],
        ),
      );
    }

    // Can rate → show rating button + skip
    if (_canRate) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFFCCCCCC).withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, -2))
          ],
        ),
        padding:
            EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 48.h,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onTapRating,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.s16)),
                  elevation: 0,
                ),
                child: Text('تقييم الخدمة',
                    style: getBoldStyle(
                        color: AppColors.white, fontSize: FontSize.s16)),
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              height: 40.h,
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.s16)),
                ),
                child: Text('تخطي',
                    style: getRegularStyle(
                        color: AppColors.grey, fontSize: FontSize.s14)),
              ),
            ),
          ],
        ),
      );
    }

    // Not completed or already rated → just back button
    return const SizedBox.shrink();
  }
}
