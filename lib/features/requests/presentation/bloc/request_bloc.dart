import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_gofull/core/usecases/usecase.dart';
import 'package:project_gofull/features/requests/domain/usecases/cancel_request_usecase.dart';
import 'package:project_gofull/features/requests/domain/usecases/create_fuel_request_usecase.dart';
import 'package:project_gofull/features/requests/domain/usecases/create_towing_request_usecase.dart';
import 'package:project_gofull/features/requests/domain/usecases/get_request_details_usecase.dart';
import 'package:project_gofull/features/requests/domain/usecases/get_requests_usecase.dart';
import 'package:project_gofull/features/requests/domain/usecases/rate_provider_usecase.dart';
import 'package:project_gofull/features/requests/domain/repositories/request_repository.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_event.dart';
import 'package:project_gofull/features/requests/presentation/bloc/request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  final CreateFuelRequestUseCase createFuel;
  final CreateTowingRequestUseCase createTowing;
  final GetRequestsUseCase getRequests;
  final GetRequestDetailsUseCase getDetails;
  final CancelRequestUseCase cancelRequest;
  final RateProviderUseCase rateProvider;
  final RequestRepository repository;

  RequestBloc({
    required this.createFuel,
    required this.createTowing,
    required this.getRequests,
    required this.getDetails,
    required this.cancelRequest,
    required this.rateProvider,
    required this.repository,
  }) : super(const RequestInitial()) {
    on<LoadRequestsEvent>(_onLoadRequests);
    on<CreateFuelRequestEvent>(_onCreateFuel);
    on<CreateTowingRequestEvent>(_onCreateTowing);
    // Drop concurrent polls — only process the latest. Prevents racing
    // between overlapping GET /driver/requests/{id} calls.
    on<LoadRequestDetailsEvent>(_onLoadDetails, transformer: droppable());
    on<CancelRequestEvent>(_onCancel);
    on<CheckUnratedOrderEvent>(_onCheckUnrated);
    on<RateProviderEvent>(_onRate);
  }

  Future<void> _onLoadRequests(
      LoadRequestsEvent event, Emitter<RequestState> emit) async {
    emit(const RequestLoading());
    final result = await getRequests(const NoParams());
    result.fold(
      (f) => emit(RequestError(f.message)),
      (list) => emit(RequestsLoaded(list)),
    );
  }

  Future<void> _onCreateFuel(
      CreateFuelRequestEvent event, Emitter<RequestState> emit) async {
    emit(const RequestLoading());
    final result = await createFuel(CreateFuelRequestParams(
      latitude: event.latitude, longitude: event.longitude,
      address: event.address, fuelType: event.fuelType,
      fuelQuantity: event.fuelQuantity, notes: event.notes,
    ));
    result.fold(
      (f) => emit(RequestError(f.message)),
      (r) => emit(RequestCreated(r)),
    );
  }

  Future<void> _onCreateTowing(
      CreateTowingRequestEvent event, Emitter<RequestState> emit) async {
    emit(const RequestLoading());
    final result = await createTowing(CreateTowingRequestParams(
      latitude: event.latitude, longitude: event.longitude,
      address: event.address,
      destinationLatitude: event.destinationLatitude,
      destinationLongitude: event.destinationLongitude,
      destinationAddress: event.destinationAddress,
      plateNumber: event.plateNumber, notes: event.notes,
    ));
    result.fold(
      (f) => emit(RequestError(f.message)),
      (r) => emit(RequestCreated(r)),
    );
  }

  Future<void> _onLoadDetails(
      LoadRequestDetailsEvent event, Emitter<RequestState> emit) async {
    // Only emit Loading for the VERY FIRST fetch (initial state).
    // Subsequent polls should not disrupt the UI with a Loading state.
    if (state is RequestInitial) {
      emit(const RequestLoading());
    }
    final result = await getDetails(GetRequestDetailsParams(id: event.id));
    result.fold(
      (f) => emit(RequestError(f.message)),
      (r) => emit(RequestDetailsLoaded(r)),
    );
  }

  Future<void> _onCancel(
      CancelRequestEvent event, Emitter<RequestState> emit) async {
    emit(const RequestLoading());
    final result = await cancelRequest(CancelRequestParams(id: event.id));
    result.fold(
      (f) => emit(RequestError(f.message)),
      (_) => emit(const RequestCancelled()),
    );
  }

  Future<void> _onCheckUnrated(
      CheckUnratedOrderEvent event, Emitter<RequestState> emit) async {
    final result = await repository.getUnratedOrder();
    result.fold(
      (_) => emit(const NoUnratedOrder()),
      (req) => req != null
          ? emit(UnratedOrderFound(req))
          : emit(const NoUnratedOrder()),
    );
  }

  Future<void> _onRate(
      RateProviderEvent event, Emitter<RequestState> emit) async {
    emit(const RequestLoading());
    final result = await rateProvider(RateProviderParams(
      requestId: event.requestId, rating: event.rating, comment: event.comment,
    ));
    result.fold(
      (f) => emit(RequestError(f.message)),
      (r) => emit(ProviderRated(r)),
    );
  }
}
