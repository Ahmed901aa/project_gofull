import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/routes/routes.dart';
import 'package:project_gofull/features/shell/presentation/screens/bottom_nav_shell.dart';
import 'package:project_gofull/core/widgets/dotted_circle_container.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';
import 'package:project_gofull/features/fuel/presentation/widgets/fuel_complete_payment_section.dart';
import 'package:project_gofull/features/fuel/presentation/widgets/fuel_complete_safety_section.dart';
import 'package:project_gofull/features/fuel/presentation/widgets/fuel_service_details.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
import 'package:project_gofull/l10n/app_localizations.dart';

List<String> _getSafetyItems(BuildContext context) {
  final l10n = S.of(context);
  return [
    l10n.safetyItemTankCap,
    l10n.safetyItemInspection,
    l10n.safetyItemPayment,
  ];
}

class FuelCompleteScreen extends StatefulWidget {
  final int? requestId;
  const FuelCompleteScreen({super.key, this.requestId});

  @override
  State<FuelCompleteScreen> createState() => _FuelCompleteScreenState();
}

class _FuelCompleteScreenState extends State<FuelCompleteScreen> {
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

  @override
  void initState() {
    super.initState();
    BottomNavShell.markCompletedInApp();
    _requestBloc = sl<RequestBloc>();
    if (widget.requestId != null) {
      _requestBloc.add(LoadRequestDetailsEvent(widget.requestId!));
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Map<String, String> _buildData(ServiceRequestEntity req, String cur, S l10n) {
    final qty = req.fuelQuantity;
    final qtyText = (qty != null && qty != '0') ? '$qty ${l10n.litersUnit}' : l10n.fullTankFill;
    return {
      'quantity': qtyText,
      'fuelType': req.fuelType ?? l10n.gasolineFuel,
      'pricePerLiter': '${req.pricePerLiter ?? '—'} $cur',
      'subtotal': '${req.subtotal ?? '—'} $cur',
      'serviceFee': '${req.serviceFee ?? '—'} $cur',
      'total': '${req.total ?? '—'} $cur',
    };
  }

  void _onTapRating() {
    setState(() => _showRating = true);
    // Scroll to rating section after it builds
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
    final orderId = widget.requestId;
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
    final l10n = S.of(context);
    final cur = context.read<AppConfigBloc>().state.currency;

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
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(Insets.s16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: Insets.s16),
                      const Center(child: DottedCircleContainer(imagePath: 'assets/images/shield.gif')),
                      SizedBox(height: Insets.s16),
                      Text(l10n.fuelCompleteSuccess, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18), textAlign: TextAlign.center),
                      SizedBox(height: 6.h),
                      Text(l10n.fuelCompleteSubtitle, style: getRegularStyle(color: AppColors.neutral800, fontSize: FontSize.s14), textAlign: TextAlign.center),
                      SizedBox(height: Insets.s24),
                      FuelCompleteSafetySection(items: _getSafetyItems(context)),
                      SizedBox(height: Insets.s16),
                      if (_request != null) ...[
                        FuelServiceDetails(data: _buildData(_request!, cur, S.of(context))),
                        SizedBox(height: Insets.s16),
                        FuelCompletePaymentSection(data: _buildData(_request!, cur, S.of(context))),
                      ] else
                        const Center(child: CircularProgressIndicator(color: AppColors.primary)),
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
        Text(l10n.howWasYourExperience, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18)),
        SizedBox(height: 2.h),
        Text(
          l10n.feedbackHelpsImprove,
          style: getRegularStyle(color: AppColors.neutral900, fontSize: FontSize.s14),
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
                  _rating >= star ? Icons.star_rounded : Icons.star_outline_rounded,
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
            child: Text(l10n.addNotes, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s14)),
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
                hintText: l10n.addNotesHint,
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
        Text(l10n.thankYouForRating, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18)),
        SizedBox(height: 4.h),
        Text(
          l10n.ratingSubmittedSuccess,
          style: getRegularStyle(color: AppColors.neutral800, fontSize: FontSize.s14),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: Insets.s8),
        // Show the stars they selected
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
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.close_rounded, size: 24.sp, color: const Color(0xFF0E0E0E))),
              Text(l10n.fuelCompleteTitle, style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20)),
              Icon(Icons.info_outline_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
            ]),
          ),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
        ]),
      );

  Widget _buildBottomButton(BuildContext context) {
    // After rating submitted → go home
    if (_ratingSubmitted) {
      return Container(
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
          boxShadow: [BoxShadow(color: const Color(0xFFCCCCCC).withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, -2))]),
        padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s16),
        child: SizedBox(height: 48.h, width: double.infinity, child: ElevatedButton(
          onPressed: () => Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)), elevation: 0),
          child: Text(l10n.backToHome, style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s16)),
        )),
      );
    }

    // Rating form visible → submit button
    if (_showRating) {
      return Container(
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
          boxShadow: [BoxShadow(color: const Color(0xFFCCCCCC).withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, -2))]),
        padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 48.h, width: double.infinity, child: ElevatedButton(
              onPressed: _rating == 0 ? null : _submitRating,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)), elevation: 0),
              child: Text(l10n.submitRating, style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s16)),
            )),
            SizedBox(height: 8.h),
            SizedBox(height: 40.h, width: double.infinity, child: TextButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false),
              style: TextButton.styleFrom(foregroundColor: AppColors.grey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16))),
              child: Text(l10n.skip, style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s14)),
            )),
          ],
        ),
      );
    }

    // Default → show rating button + skip
    return Container(
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
        boxShadow: [BoxShadow(color: const Color(0xFFCCCCCC).withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, -2))]),
      padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 48.h, width: double.infinity, child: ElevatedButton(
            onPressed: _onTapRating,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)), elevation: 0),
            child: Text(l10n.rateService, style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s16)),
          )),
          SizedBox(height: 8.h),
          SizedBox(height: 40.h, width: double.infinity, child: TextButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false),
            style: TextButton.styleFrom(foregroundColor: AppColors.grey,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16))),
            child: Text(l10n.skip, style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.s14)),
          )),
        ],
      ),
    );
  }
}
