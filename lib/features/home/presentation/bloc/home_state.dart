import 'package:equatable/equatable.dart';
import 'package:project_gofull/features/home/domain/entities/offer_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<OfferEntity> offers;
  const HomeLoaded(this.offers);

  @override
  List<Object?> get props => [offers];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
