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
import 'package:project_gofull/core/widgets/dotted_circle_container.dart';
import 'package:project_gofull/features/app_config/presentation/bloc/app_config_bloc.dart';
import 'package:project_gofull/features/fuel/presentation/widgets/fuel_complete_payment_section.dart';
import 'package:project_gofull/features/fuel/presentation/widgets/fuel_complete_safety_section.dart';
import 'package:project_gofull/features/fuel/presentation/widgets/fuel_service_details.dart';
import 'package:project_gofull/features/orders/models/order_data.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_bloc.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';

const _safetyItems = [
  'إغلاق الخزان: تأكد من إغلاق غطاء وقود السيارة جيداً.',
  'المعاينة النهائية: تأكد من عدم وجود أي انسكابات وقود حول السيارة.',
  'الدفع: يرجى سداد المبلغ الإجمالي للسائق (كاش) أو عبر التطبيق.',
];

class FuelCompleteScreen extends StatefulWidget {
  final int? requestId;
  const FuelCompleteScreen({super.key, this.requestId});

  @override
  State<FuelCompleteScreen> createState() => _FuelCompleteScreenState();
}

class _FuelCompleteScreenState extends State<FuelCompleteScreen> {
  late final RequestBloc _requestBloc;
  ServiceRequestEntity? _request;

  @override
  void initState() {
    super.initState();
    _requestBloc = sl<RequestBloc>();
    if (widget.requestId != null) {
      _requestBloc.add(LoadRequestDetailsEvent(widget.requestId!));
    }
  }

  Map<String, String> _buildData(ServiceRequestEntity req, String cur) {
    final qty = req.fuelQuantity;
    final qtyText = (qty != null && qty != '0') ? '$qty لتر' : 'تعبئة كاملة';
    return {
      'quantity': qtyText,
      'fuelType': req.fuelType ?? 'بنزين',
      'pricePerLiter': '${req.pricePerLiter ?? '—'} $cur',
      'subtotal': '${req.subtotal ?? '—'} $cur',
      'serviceFee': '${req.serviceFee ?? '—'} $cur',
      'total': '${req.total ?? '—'} $cur',
    };
  }

  @override
  Widget build(BuildContext context) {
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
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(Insets.s16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: Insets.s16),
                      const Center(child: DottedCircleContainer(imagePath: 'assets/images/shield.gif')),
                      SizedBox(height: Insets.s16),
                      Text('تمت تعبئة سيارتك بالوقود بنجاح!', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s18), textAlign: TextAlign.center),
                      SizedBox(height: 6.h),
                      Text('تم تعبئة الوقود بنجاح. يرجى التأكد من إغلاق غطاء الوقود وسلامة السيارة.', style: getRegularStyle(color: AppColors.neutral800, fontSize: FontSize.s14), textAlign: TextAlign.center),
                      SizedBox(height: Insets.s24),
                      const FuelCompleteSafetySection(items: _safetyItems),
                      SizedBox(height: Insets.s16),
                      if (_request != null) ...[
                        FuelServiceDetails(data: _buildData(_request!, cur)),
                        SizedBox(height: Insets.s16),
                        FuelCompletePaymentSection(data: _buildData(_request!, cur)),
                      ] else
                        const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                      SizedBox(height: Insets.s16),
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

  Widget _buildHeader(BuildContext context) => Container(
        color: AppColors.white,
        child: Column(children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s12),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.close_rounded, size: 24.sp, color: const Color(0xFF0E0E0E))),
              Text('تمت التعبئة بنجاح', style: getBoldStyle(color: const Color(0xFF0E0E0E), fontSize: FontSize.s20)),
              Icon(Icons.info_outline_rounded, size: 24.sp, color: const Color(0xFF0E0E0E)),
            ]),
          ),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
        ]),
      );

  Widget _buildBottomButton(BuildContext context) {
    final orderId = widget.requestId?.toString() ?? _request?.id.toString() ?? '';
    return Container(
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.s16)),
        boxShadow: [BoxShadow(color: const Color(0xFFCCCCCC).withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, -2))]),
      padding: EdgeInsets.fromLTRB(Insets.s16, Insets.s12, Insets.s16, Insets.s16),
      child: SizedBox(height: 48.h, width: double.infinity, child: ElevatedButton(
        onPressed: () => Navigator.pushReplacementNamed(context, Routes.tripDetails,
            arguments: TripDetailsArgs(orderId: orderId, status: OrderStatus.completed, isRated: false)),
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.s16)), elevation: 0),
        child: Text('تقييم الرحلة', style: getBoldStyle(color: AppColors.white, fontSize: FontSize.s16)),
      )),
    );
  }
}
