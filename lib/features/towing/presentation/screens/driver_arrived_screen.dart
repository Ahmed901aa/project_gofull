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
import 'package:project_gofull/features/shell/presentation/screens/bottom_nav_shell.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
import '../widgets/arrived_car_photos.dart';
import '../widgets/arrived_payment_card.dart';
import '../widgets/arrived_safety_card.dart';
import '../widgets/gif_circle.dart';

class DriverArrivedScreen extends StatefulWidget {
  final TripInProgressArgs? args;
  const DriverArrivedScreen({super.key, this.args});

  @override
  State<DriverArrivedScreen> createState() => _DriverArrivedScreenState();
}

class _DriverArrivedScreenState extends State<DriverArrivedScreen> {
  late final RequestBloc _requestBloc;
  String _subtotal = '—';
  String _serviceFee = '—';
  String _total = '—';

  // Rating state
  bool _showRating = false;
  int _rating = 0;
  final _notesController = TextEditingController();
  static const int _maxNoteLength = 80;
  bool _ratingSubmitted = false;
  final _scrollController = ScrollController();
  final _ratingKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    BottomNavShell.markCompletedInApp();
    _requestBloc = sl<RequestBloc>();
    final reqId = widget.args?.requestId;
    if (reqId != null) {
      _requestBloc.add(LoadRequestDetailsEvent(reqId));
    }
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
    final orderId = widget.args?.requestId;
    if (orderId != null && _rating > 0) {
      sl<RequestBloc>().add(RateProviderEvent(
        requestId: orderId,
        rating: _rating,
        comment: _notesController.text.isNotEmpty ? _notesController.text : null,
      ));
    }
    setState(() => _ratingSubmitted = true);
  }

  @override
  Widget build(BuildContext context) {
    final config = context.read<AppConfigBloc>().state;
    final cur = config.currency;

    return BlocProvider.value(
      value: _requestBloc,
      child: BlocListener<RequestBloc, RequestState>(
        listener: (context, state) {
          if (state is RequestDetailsLoaded) {
            final req = state.request;
            setState(() {
              _subtotal = req.subtotal != null ? '${req.subtotal} $cur' : '— $cur';
              _serviceFee = req.serviceFee != null
                  ? '${req.serviceFee} $cur'
                  : '${config.serviceFee.toStringAsFixed(2)} $cur';
              _total = req.total != null ? '${req.total} $cur' : '— $cur';
            });
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBg,
          body: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(Insets.s16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: Insets.s16),
                      Center(child: GifCircle(imagePath: 'assets/images/shield.gif')),
                      SizedBox(height: Insets.s16),
                      Text(
                        'تمت المهمة بنجاح!',
                        style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'تم إنزال السيارة في وجهة التوصيل المحددة. يرجى التأكد من سلامة السيارة قبل إتمام الدفع.',
                        style: getRegularStyle(color: AppColors.neutral800, fontSize: FontSize.s14),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: Insets.s24),
                      const ArrivedSafetyCard(),
                      SizedBox(height: Insets.s16),
                      const ArrivedCarPhotos(),
                      SizedBox(height: Insets.s16),
                      ArrivedPaymentCard(
                        subtotal: _subtotal,
                        serviceFee: _serviceFee,
                        total: _total,
                      ),
                      SizedBox(height: Insets.s16),

                      // ── Inline Rating Section ──────────────────────
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
                    ],
                  ),
                ),
              ),
              _buildBottomButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // ── Rating Form ─────────────────────────────────────────────
  Widget _buildRatingForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('كيف كانت تجربتك؟', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18)),
        SizedBox(height: 2.h),
        Text(
          'ملاحظاتك تساعدنا في تحسين جودة خدماتنا وتطوير أداء السائقين.',
          style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s14),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: Insets.s16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            final star = 5 - i;
            return GestureDetector(
              onTap: () => setState(() => _rating = star),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Icon(
                  _rating >= star ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 40.sp,
                  color: const Color(0xFFFFB800),
                ),
              ),
            );
          }),
        ),
        if (_rating > 0) ...[
          SizedBox(height: Insets.s16),
          Align(
            alignment: Alignment.centerRight,
            child: Text('أضف ملاحظاتك', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14)),
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
              style: getRegularStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14),
              decoration: InputDecoration(
                hintText: 'اكتب هنا أي تفاصيل إضافية تود مشاركتها...',
                hintStyle: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s14),
                contentPadding: EdgeInsets.symmetric(horizontal: Insets.s16, vertical: Insets.s8),
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
                style: getMediumStyle(color: AppColors.neutral900, fontSize: FontSize.s12),
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
        Icon(Icons.check_circle_rounded, size: 48.sp, color: AppColors.primary),
        SizedBox(height: Insets.s8),
        Text('شكراً لتقييمك!', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18)),
        SizedBox(height: 4.h),
        Text(
          'تم إرسال تقييمك بنجاح. شكراً لمساعدتنا في تحسين خدماتنا.',
          style: getRegularStyle(color: AppColors.neutral800, fontSize: FontSize.s14),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: Insets.s8),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Icon(
                _rating >= (i + 1) ? Icons.star_rounded : Icons.star_outline_rounded,
                size: 28.sp,
                color: const Color(0xFFFFB800),
              ),
            )),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
        color: AppColors.white,
        child: Column(children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 24.sp),
                Text('وصول السيارة',
                    style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20)),
                Icon(Icons.info_outline_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
        ]),
      );

  Widget _buildBottomButton(BuildContext context) {
    if (_ratingSubmitted) {
      return Container(
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
          boxShadow: const [BoxShadow(color: Color(0x0ACCCCCC), blurRadius: 4, offset: Offset(0, -4))]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
              child: SizedBox(width: double.infinity, height: 48.h, child: ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)), elevation: 0),
                child: Text('العودة للرئيسية', style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s16)),
              )),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      );
    }

    if (_showRating) {
      return Container(
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
          boxShadow: const [BoxShadow(color: Color(0x0ACCCCCC), blurRadius: 4, offset: Offset(0, -4))]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, 0),
              child: SizedBox(width: double.infinity, height: 48.h, child: ElevatedButton(
                onPressed: _rating == 0 ? null : _submitRating,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)), elevation: 0),
                child: Text('إرسال التقييم', style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s16)),
              )),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(Insets.s16, 8.h, Insets.s16, Insets.s12),
              child: SizedBox(width: double.infinity, height: 40.h, child: TextButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false),
                style: TextButton.styleFrom(foregroundColor: AppColors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16))),
                child: Text('تخطي', style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s14)),
              )),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
        boxShadow: const [BoxShadow(color: Color(0x0ACCCCCC), blurRadius: 4, offset: Offset(0, -4))]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, 0),
            child: SizedBox(width: double.infinity, height: 48.h, child: ElevatedButton(
              onPressed: _onTapRating,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)), elevation: 0),
              child: Text('تقييم الخدمة', style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s16)),
            )),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(Insets.s16, 8.h, Insets.s16, Insets.s12),
            child: SizedBox(width: double.infinity, height: 40.h, child: TextButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false),
              style: TextButton.styleFrom(foregroundColor: AppColors.grey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16))),
              child: Text('تخطي', style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s14)),
            )),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
