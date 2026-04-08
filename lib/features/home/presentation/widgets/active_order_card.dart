import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_gofull/core/di/injection_container.dart';
import 'package:project_gofull/core/resources/color_manager.dart';
import 'package:project_gofull/core/resources/font_manager.dart';
import 'package:project_gofull/core/resources/styles_manager.dart';
import 'package:project_gofull/core/resources/values_manager.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';

class ActiveOrderCard extends StatelessWidget {
  final ServiceRequestEntity? activeOrder;
  final VoidCallback? onCancelled;
  const ActiveOrderCard({super.key, this.activeOrder, this.onCancelled});

  @override
  Widget build(BuildContext context) {
    final order = activeOrder;
    if (order == null) return const SizedBox.shrink();

    final config = context.read<AppConfigBloc>().state;
    final cur = config.currency;
    final address = order.driverAddress ?? 'الموقع الحالي';
    final price = order.total != null
        ? '${double.tryParse(order.total!)?.toStringAsFixed(2) ?? '—'} $cur'
        : '—';
    final isFuel = order.isFuelDelivery;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: Sizes.s12),
            child: Text('طلبك الحالي',
                style: getSemiBoldStyle(
                    color: const Color(0xFF0E0E0E), fontSize: FontSize.s18),
                textAlign: TextAlign.right),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.neutral50,
              borderRadius: BorderRadius.circular(AppRadius.s16),
              border: Border.all(color: AppColors.neutral500),
            ),
            padding: EdgeInsets.all(Insets.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Service badge + status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Insets.s12, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.s16),
                      ),
                      child: Text(
                        isFuel ? 'خدمة وقود' : 'خدمة ونش',
                        style: getSemiBoldStyle(
                            color: AppColors.primary, fontSize: FontSize.s12),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Insets.s8, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.s8),
                      ),
                      child: Text(
                        _statusAr,
                        style: getMediumStyle(
                            color: AppColors.warning, fontSize: FontSize.s12),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Insets.s12),

                // Address
                Row(children: [
                  Icon(Icons.location_on_rounded,
                      size: 18.sp, color: AppColors.primary),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(address,
                        style: getMediumStyle(
                            color: const Color(0xFF0E0E0E),
                            fontSize: FontSize.s14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                ]),
                SizedBox(height: Insets.s12),

                // Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('الإجمالي',
                        style: getRegularStyle(
                            color: AppColors.neutral800,
                            fontSize: FontSize.s14)),
                    Text(price,
                        style: getBoldStyle(
                            color: AppColors.primary,
                            fontSize: FontSize.s16)),
                  ],
                ),
                SizedBox(height: Insets.s12),

                // Cancel button
                SizedBox(
                  width: double.infinity,
                  height: 40.h,
                  child: OutlinedButton(
                    onPressed: () => _confirmCancel(context, order.id),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.s8),
                      ),
                    ),
                    child: Text('إلغاء الطلب',
                        style: getSemiBoldStyle(
                            color: AppColors.error,
                            fontSize: FontSize.s14)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmCancel(BuildContext context, int orderId) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('إلغاء الطلب',
              style: getBoldStyle(
                  color: const Color(0xFF0E0E0E), fontSize: FontSize.s18)),
          content: Text('هل أنت متأكد من رغبتك في إلغاء هذا الطلب؟',
              style: getRegularStyle(
                  color: AppColors.neutral800, fontSize: FontSize.s14)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('لا',
                  style: getMediumStyle(
                      color: AppColors.neutral800, fontSize: FontSize.s14)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _cancelOrder(context, orderId);
              },
              child: Text('نعم، إلغاء',
                  style: getMediumStyle(
                      color: AppColors.error, fontSize: FontSize.s14)),
            ),
          ],
        ),
      ),
    );
  }

  void _cancelOrder(BuildContext context, int orderId) {
    final bloc = sl<RequestBloc>()..add(CancelRequestEvent(orderId));
    // Listen for result and refresh
    bloc.stream.listen((state) {
      if (state is RequestCancelled) {
        onCancelled?.call();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('تم إلغاء الطلب بنجاح'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          );
        }
      }
    });
  }

  String get _statusAr {
    switch (activeOrder?.status) {
      case 'pending':
        return 'في انتظار القبول';
      case 'accepted':
        return 'تم القبول';
      case 'en_route':
        return 'في الطريق';
      case 'arrived':
        return 'وصل';
      case 'in_progress':
        return 'قيد التنفيذ';
      default:
        return 'قيد المعالجة';
    }
  }
}
