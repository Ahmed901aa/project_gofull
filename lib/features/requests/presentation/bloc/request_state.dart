import 'package:equatable/equatable.dart';
import 'package:project_gofull/features/requests/domain/entities/rating_entity.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';

abstract class RequestState extends Equatable {
  const RequestState();
  @override
  List<Object?> get props => [];
}

class RequestInitial extends RequestState {
  const RequestInitial();
}

class RequestLoading extends RequestState {
  const RequestLoading();
}

class RequestCreated extends RequestState {
  final ServiceRequestEntity request;
  const RequestCreated(this.request);
  @override
  List<Object?> get props => [request];
}

class RequestsLoaded extends RequestState {
  final List<ServiceRequestEntity> requests;
  const RequestsLoaded(this.requests);
  @override
  List<Object?> get props => [requests];
}

class RequestDetailsLoaded extends RequestState {
  final ServiceRequestEntity request;
  const RequestDetailsLoaded(this.request);
  @override
  List<Object?> get props => [request];
}

class RequestCancelled extends RequestState {
  const RequestCancelled();
}

class ProviderRated extends RequestState {
  final RatingEntity rating;
  const ProviderRated(this.rating);
  @override
  List<Object?> get props => [rating];
}

class RequestError extends RequestState {
  final String message;
  const RequestError(this.message);
  @override
  List<Object?> get props => [message];
}
