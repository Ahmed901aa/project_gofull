import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';

/// Shows the rating bottom sheet for an unrated completed order.
/// Returns `true` if the user rated, `false` if dismissed.
Future<bool> showRatingBottomSheet(
    BuildContext context, ServiceRequestEntity request) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _RatingSheet(request: request),
  );
  return result == true;
}

class _RatingSheet extends StatefulWidget {
  final ServiceRequestEntity request;
  const _RatingSheet({required this.request});

  @override
  State<_RatingSheet> createState() => _RatingSheetState();
}

class _RatingSheetState extends State<_RatingSheet> {
  int _rating = 0;
  final _commentController = TextEditingController();
  late final RequestBloc _bloc;
  bool _submitting = false;

  String get _providerName {
    final prov = widget.request.providerInfo;
    final user = (prov?['user'] as Map<String, dynamic>?) ?? {};
    return (user['name'] as String?) ?? 'مزود الخدمة';
  }

  @override
  void initState() {
    super.initState();
    _bloc = sl<RequestBloc>();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_rating == 0) return;
    setState(() => _submitting = true);
    _bloc.add(RateProviderEvent(
      requestId: widget.request.id,
      rating: _rating,
      comment: _commentController.text.isNotEmpty
          ? _commentController.text
          : null,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<RequestBloc, RequestState>(
        listener: (context, state) {
          if (state is ProviderRated) {
            Navigator.pop(context, true);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('شكراً لتقييمك'),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            );
          } else if (state is RequestError) {
            setState(() => _submitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            padding: EdgeInsets.fromLTRB(
                Insets.s16, Insets.s8, Insets.s16, Insets.s16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: Insets.s16),
                  decoration: BoxDecoration(
                    color: AppColors.neutral600,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),

                // Title
                Text(
                  'قيّم الخدمة',
                  style: getBoldStyle(
                      color: const Color(0xFF0E0E0E),
                      fontSize: FontSize.s20),
                ),
                SizedBox(height: 4.h),

                // Subtitle: service type + provider name
                Text(
                  '${widget.request.isFuelDelivery ? 'خدمة وقود' : 'خدمة سحب'} — $_providerName',
                  style: getRegularStyle(
                      color: AppColors.neutral800,
                      fontSize: FontSize.s14),
                ),
                SizedBox(height: Insets.s24),

                // Stars
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final starIndex = i + 1;
                    return GestureDetector(
                      onTap: () => setState(() => _rating = starIndex),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Icon(
                          starIndex <= _rating
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          size: 44.sp,
                          color: starIndex <= _rating
                              ? const Color(0xFFFFB800)
                              : AppColors.neutral600,
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 8.h),

                // Rating label
                Text(
                  _rating == 0
                      ? 'اضغط على النجوم للتقييم'
                      : _ratingLabel(_rating),
                  style: getMediumStyle(
                    color: _rating == 0
                        ? AppColors.neutral800
                        : AppColors.primary,
                    fontSize: FontSize.s14,
                  ),
                ),
                SizedBox(height: Insets.s16),

                // Comment
                TextField(
                  controller: _commentController,
                  maxLines: 3,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    hintText: 'اكتب تعليقك هنا (اختياري)',
                    hintStyle: getRegularStyle(
                        color: AppColors.neutral800,
                        fontSize: FontSize.s14),
                    filled: true,
                    fillColor: AppColors.scaffoldBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.s12),
                      borderSide:
                          const BorderSide(color: AppColors.neutral500),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.s12),
                      borderSide:
                          const BorderSide(color: AppColors.neutral500),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.s12),
                      borderSide:
                          const BorderSide(color: AppColors.primary),
                    ),
                    contentPadding: EdgeInsets.all(Insets.s12),
                  ),
                ),
                SizedBox(height: Insets.s16),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed:
                        _rating > 0 && !_submitting ? _submit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: const Color(0xFFD9DADB),
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.s16),
                      ),
                      elevation: 0,
                    ),
                    child: _submitting
                        ? SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: const CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: AppColors.white),
                          )
                        : Text(
                            'إرسال التقييم',
                            style: getBoldStyle(
                                color: AppColors.white,
                                fontSize: FontSize.s16),
                          ),
                  ),
                ),

                // Bottom safe area
                SizedBox(
                    height: MediaQuery.of(context).padding.bottom + 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _ratingLabel(int r) {
    switch (r) {
      case 1:
        return 'سيء';
      case 2:
        return 'مقبول';
      case 3:
        return 'جيد';
      case 4:
        return 'جيد جداً';
      case 5:
        return 'ممتاز';
      default:
        return '';
    }
  }
}
