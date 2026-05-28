import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/core/widgets/app_notification.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
import 'package:project_gofull/l10n/app_localizations.dart';
import 'package:project_gofull/core/resources/app_theme.dart';

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

  String _providerName(BuildContext context) {
    final prov = widget.request.providerInfo;
    final user = (prov?['user'] as Map<String, dynamic>?) ?? {};
    return (user['name'] as String?) ?? S.of(context).serviceProviderDefault;
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
    if (_rating == 0) {

      return;

    }
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
    final l10n = S.of(context);
    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<RequestBloc, RequestState>(
        listener: (context, state) {
          if (state is ProviderRated) {
            Navigator.pop(context, true);
            AppSnackbar.success(context, l10n.thankYouRating);
          } else if (state is RequestError) {
            setState(() => _submitting = false);
            AppSnackbar.error(context, l10n.ratingFailed);
          }
        },
        child: Container(
            decoration: BoxDecoration(
              color: context.colors.surface,
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
                    color: context.colors.border,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),

                // Title
                Text(
                  l10n.rateService,
                  style: getBoldStyle(
                      color: context.colors.textPrimary,
                      fontSize: FontSize.s20),
                ),
                SizedBox(height: 4.h),

                // Subtitle: service type + provider name
                Text(
                  '${widget.request.isFuelDelivery ? l10n.fuelService : l10n.towService} — ${_providerName(context)}',
                  style: getRegularStyle(
                      color: context.colors.textSecondary,
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
                              ? context.colors.gold
                              : context.colors.border,
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 8.h),

                // Rating label
                Text(
                  _rating == 0
                      ? l10n.tapStarsToRate
                      : _ratingLabel(_rating, l10n),
                  style: getMediumStyle(
                    color: _rating == 0
                        ? context.colors.textSecondary
                        : context.colors.primary,
                    fontSize: FontSize.s14,
                  ),
                ),
                SizedBox(height: Insets.s16),

                // Comment
                TextField(
                  controller: _commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: l10n.writeCommentHint,
                    hintStyle: getRegularStyle(
                        color: context.colors.textSecondary,
                        fontSize: FontSize.s14),
                    filled: true,
                    fillColor: context.colors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.s12),
                      borderSide:
                          BorderSide(color: context.colors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.s12),
                      borderSide:
                          BorderSide(color: context.colors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.s12),
                      borderSide:
                          BorderSide(color: context.colors.primary),
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
                      backgroundColor: context.colors.primary,
                      disabledBackgroundColor: context.colors.border,
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
                            child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: context.colors.surface),
                          )
                        : Text(
                            l10n.submitRatingBtn,
                            style: getBoldStyle(
                                color: context.colors.surface,
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
    );
  }

  String _ratingLabel(int r, S l10n) {
    switch (r) {
      case 1:
        return l10n.ratingBad;
      case 2:
        return l10n.ratingAcceptable;
      case 3:
        return l10n.ratingGood;
      case 4:
        return l10n.ratingVeryGood;
      case 5:
        return l10n.ratingExcellent;
      default:
        return '';
    }
  }
}
