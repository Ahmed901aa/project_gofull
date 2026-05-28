import 'package:project_gofull/core/usecases/usecase.dart';
import 'package:project_gofull/features/home/domain/usecases/get_offers_usecase.dart';
import 'package:project_gofull/features/home/presentation/bloc/home_event.dart';
import 'package:project_gofull/features/home/presentation/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetOffersUseCase getOffers;

  HomeBloc({required this.getOffers}) : super(const HomeInitial()) {
    on<LoadOffersRequested>(_onLoadOffers);
  }

  Future<void> _onLoadOffers(
    LoadOffersRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());
    final result = await getOffers(const NoParams());
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (offers) => emit(HomeLoaded(offers)),
    );
  }
}
