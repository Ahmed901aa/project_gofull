import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_gofull/core/usecases/usecase.dart';
import 'package:project_gofull/features/provider/domain/usecases/accept_request_usecase.dart';
import 'package:project_gofull/features/provider/domain/usecases/get_history_usecase.dart';
import 'package:project_gofull/features/provider/domain/usecases/get_active_request_usecase.dart';
import 'package:project_gofull/features/provider/domain/usecases/get_pending_requests_usecase.dart';
import 'package:project_gofull/features/provider/domain/usecases/get_profile_usecase.dart';
import 'package:project_gofull/features/provider/domain/usecases/rate_driver_usecase.dart';
import 'package:project_gofull/features/provider/domain/usecases/reject_request_usecase.dart';
import 'package:project_gofull/features/provider/domain/usecases/toggle_availability_usecase.dart';
import 'package:project_gofull/features/provider/domain/usecases/cancel_order_usecase.dart';
import 'package:project_gofull/features/provider/domain/usecases/update_status_usecase.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_event.dart';
import 'package:project_gofull/features/provider/presentation/bloc/provider_state.dart';

class ProviderBloc extends Bloc<ProviderEvent, ProviderState> {
  final GetProfileUseCase getProfile;
  final ToggleAvailabilityUseCase toggleAvailability;
  final GetActiveRequestUseCase getActiveRequest;
  final GetPendingRequestsUseCase getPendingRequests;
  final GetHistoryUseCase getHistory;
  final AcceptRequestUseCase acceptRequest;
  final RejectRequestUseCase rejectRequest;
  final UpdateStatusUseCase updateStatus;
  final RateDriverUseCase rateDriver;
  final CancelOrderUseCase cancelOrder;

  ProviderBloc({
    required this.getProfile,
    required this.toggleAvailability,
    required this.getActiveRequest,
    required this.getPendingRequests,
    required this.getHistory,
    required this.acceptRequest,
    required this.rejectRequest,
    required this.updateStatus,
    required this.rateDriver,
    required this.cancelOrder,
  }) : super(const ProviderInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<LoadActiveRequestEvent>(_onLoadActive);
    on<ToggleAvailabilityEvent>(_onToggle);
    on<LoadPendingRequestsEvent>(_onLoadPending);
    on<LoadHistoryEvent>(_onLoadHistory);
    on<AcceptRequestEvent>(_onAccept);
    on<RejectRequestEvent>(_onReject);
    on<UpdateStatusEvent>(_onUpdateStatus);
    on<RateDriverEvent>(_onRate);
    on<CancelOrderEvent>(_onCancel);
  }

  Future<void> _onLoadActive(LoadActiveRequestEvent e, Emitter<ProviderState> emit) async {
    final r = await getActiveRequest(const NoParams());
    r.fold((_) {}, (req) => emit(ActiveRequestLoaded(req)));
  }

  Future<void> _onLoadProfile(LoadProfileEvent e, Emitter<ProviderState> emit) async {
    emit(const ProviderLoading());
    final r = await getProfile(const NoParams());
    r.fold((f) => emit(ProviderError(f.message)), (p) => emit(ProfileLoaded(p)));
  }

  Future<void> _onToggle(ToggleAvailabilityEvent e, Emitter<ProviderState> emit) async {
    emit(const ProviderLoading());
    final r = await toggleAvailability(ToggleAvailabilityParams(isAvailable: e.isAvailable));
    r.fold((f) => emit(ProviderError(f.message)), (v) => emit(AvailabilityUpdated(v)));
  }

  Future<void> _onLoadPending(LoadPendingRequestsEvent e, Emitter<ProviderState> emit) async {
    // No ProviderLoading — silent poll to avoid interfering with other states
    final r = await getPendingRequests(const NoParams());
    r.fold((_) {}, (l) => emit(PendingRequestsLoaded(l)));
  }

  Future<void> _onLoadHistory(LoadHistoryEvent e, Emitter<ProviderState> emit) async {
    emit(const ProviderLoading());
    final r = await getHistory(const NoParams());
    r.fold((f) => emit(ProviderError(f.message)), (l) => emit(HistoryLoaded(l)));
  }

  Future<void> _onAccept(AcceptRequestEvent e, Emitter<ProviderState> emit) async {
    emit(const ProviderLoading());
    final r = await acceptRequest(AcceptRequestParams(id: e.id));
    r.fold((f) => emit(ProviderError(f.message)), (req) => emit(RequestAccepted(req)));
  }

  Future<void> _onReject(RejectRequestEvent e, Emitter<ProviderState> emit) async {
    emit(const ProviderLoading());
    final r = await rejectRequest(RejectRequestParams(id: e.id));
    r.fold((f) => emit(ProviderError(f.message)), (_) => emit(const RequestRejected()));
  }

  Future<void> _onUpdateStatus(UpdateStatusEvent e, Emitter<ProviderState> emit) async {
    emit(const ProviderLoading());
    final r = await updateStatus(UpdateStatusParams(id: e.id, status: e.status));
    r.fold((f) => emit(ProviderError(f.message)), (req) => emit(StatusUpdated(req)));
  }

  Future<void> _onRate(RateDriverEvent e, Emitter<ProviderState> emit) async {
    emit(const ProviderLoading());
    final r = await rateDriver(RateDriverParams(requestId: e.requestId, rating: e.rating, comment: e.comment));
    r.fold((f) => emit(ProviderError(f.message)), (rat) => emit(DriverRated(rat)));
  }

  Future<void> _onCancel(CancelOrderEvent e, Emitter<ProviderState> emit) async {
    emit(const ProviderLoading());
    final r = await cancelOrder(CancelOrderParams(id: e.id, reason: e.reason));
    r.fold((f) => emit(ProviderError(f.message)), (_) => emit(const OrderCancelledByProvider()));
  }
}
