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
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';
import 'package:project_gofull/core/widgets/app_notification.dart';

/// Banner shown on the customer home screen when there's an active order.
/// Tap → resume the order on the correct screen based on its status.
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
    // Only allow cancel while the order is still pending.
    // Once the driver has accepted, the customer must let the service proceed.
    final canCancel = order.status.trim().toLowerCase() == 'pending';

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
          InkWell(
            onTap: () => _resumeOrder(context, order),
            borderRadius: BorderRadius.circular(AppRadius.s16),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.neutral50,
                borderRadius: BorderRadius.circular(AppRadius.s16),
                border: Border.all(color: AppColors.primary, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
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
                          isFuel ? 'خدمة وقود' : 'خدمة ساحبة',
                          style: getSemiBoldStyle(
                              color: AppColors.primary,
                              fontSize: FontSize.s12),
                        ),
                      ),
                      _StatusBadge(status: order.status),
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
                  SizedBox(height: Insets.s16),

                  // Action row: Resume + Cancel
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 42.h,
                          child: ElevatedButton(
                            onPressed: () => _resumeOrder(context, order),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.s12),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('متابعة الطلب',
                                    style: getSemiBoldStyle(
                                        color: AppColors.white,
                                        fontSize: FontSize.s14)),
                                SizedBox(width: 6.w),
                                Icon(Icons.chevron_left_rounded,
                                    size: 22.sp,
                                    color: AppColors.white,
                                    textDirection: TextDirection.ltr),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (canCancel) ...[
                        SizedBox(width: Insets.s8),
                        SizedBox(
                          height: 42.h,
                          child: OutlinedButton(
                            onPressed: () =>
                                _confirmCancel(context, order.id),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.error),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.s12),
                              ),
                            ),
                            child: Text('إلغاء',
                                style: getSemiBoldStyle(
                                    color: AppColors.error,
                                    fontSize: FontSize.s14)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Navigate to the correct screen for the current order status.
  void _resumeOrder(BuildContext context, ServiceRequestEntity order) {
    final isFuel = order.isFuelDelivery;
    final status = order.status.trim().toLowerCase();

    switch (status) {
      case 'pending':
        Navigator.pushNamed(
          context,
          Routes.searchingDriver,
          arguments: SearchingArgs(
            searchingText: isFuel
                ? 'جاري البحث عن أقرب مزود وقود'
                : 'جاري البحث عن أقرب سائق ساحبة',
            subtitleText: isFuel
                ? 'نقوم الآن بمطابقة طلبك مع أقرب سيارة إمداد.'
                : 'نقوم الآن بمطابقة طلبك مع أقرب سيارة ساحبة.',
            nextRoute: Routes.driverFound,
            requestId: order.id,
            serviceType:
                isFuel ? 'fuel_delivery' : 'towing',
          ),
        );
        break;

      case 'accepted':
      case 'en_route':
        Navigator.pushNamed(
          context,
          Routes.driverFound,
          arguments: DriverFoundArgs(
            title: isFuel
                ? 'تم العثور على مزود وقود!'
                : 'تم العثور على ساحبة!',
            vehicleLabel: isFuel ? 'نوع المركبة' : 'نوع الساحبة',
            vehicleValue: isFuel ? 'سيارة إمداد وقود' : 'ساحبة هيدروليك',
            showClose: true,
            imagePath: isFuel
                ? 'assets/images/tank_truck.gif'
                : 'assets/images/magnifying_glass.gif',
            nextRoute:
                isFuel ? Routes.serviceArrived : Routes.towingStarted,
            requestId: order.id,
            serviceType: isFuel ? 'fuel_delivery' : 'towing',
          ),
        );
        break;

      case 'arrived':
      case 'in_progress':
        if (isFuel) {
          Navigator.pushNamed(
            context,
            Routes.serviceArrived,
            arguments: ServiceArrivedArgs(requestId: order.id),
          );
        } else {
          Navigator.pushNamed(
            context,
            Routes.tripInProgress,
            arguments: TripInProgressArgs(
              originAddress: order.driverAddress ?? '',
              destinationAddress: order.destinationAddress ?? '',
              requestId: order.id,
            ),
          );
        }
        break;
    }
  }

  void _confirmCancel(BuildContext context, int orderId) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      icon: Icons.cancel_rounded,
      iconColor: AppColors.error,
      title: 'إلغاء الطلب',
      subtitle: 'هل أنت متأكد من رغبتك في إلغاء هذا الطلب؟',
      confirmLabel: 'نعم، إلغاء',
      cancelLabel: 'تراجع',
      destructive: true,
    );
    if (confirmed && context.mounted) {
      _cancelOrder(context, orderId);
    }
  }

  void _cancelOrder(BuildContext context, int orderId) {
    final bloc = sl<RequestBloc>()..add(CancelRequestEvent(orderId));
    bloc.stream.listen((state) {
      if (state is RequestCancelled) {
        onCancelled?.call();
        if (context.mounted) {
          AppSnackbar.success(context, 'تم إلغاء الطلب بنجاح');
        }
      }
    });
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final info = _info(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.s8, vertical: 4.h),
      decoration: BoxDecoration(
        color: info.bg,
        borderRadius: BorderRadius.circular(AppRadius.s8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: info.fg,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            info.label,
            style: getMediumStyle(color: info.fg, fontSize: FontSize.s12),
          ),
        ],
      ),
    );
  }

  _StatusInfo _info(String s) {
    switch (s.trim().toLowerCase()) {
      case 'pending':
        return _StatusInfo(
            'في انتظار القبول', AppColors.warning, const Color(0xFFFFF3E0));
      case 'accepted':
        return _StatusInfo(
            'تم القبول', const Color(0xFF1565C0), const Color(0xFFE3F2FD));
      case 'en_route':
        return _StatusInfo(
            'في الطريق إليك', const Color(0xFF2E7D32), const Color(0xFFE8F5E9));
      case 'arrived':
        return _StatusInfo(
            'وصل إليك', const Color(0xFF0C5460), const Color(0xFFD1ECF1));
      case 'in_progress':
        return _StatusInfo('قيد التنفيذ', const Color(0xFF4A148C),
            const Color(0xFFE2D5F1));
      default:
        return _StatusInfo(
            'قيد المعالجة', AppColors.neutral800, AppColors.neutral400);
    }
  }
}

class _StatusInfo {
  final String label;
  final Color fg;
  final Color bg;
  _StatusInfo(this.label, this.fg, this.bg);
}
