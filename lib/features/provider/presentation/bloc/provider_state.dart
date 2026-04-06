import 'package:equatable/equatable.dart';
import 'package:project_gofull/features/provider/domain/entities/provider_profile_entity.dart';
import 'package:project_gofull/features/requests/domain/entities/rating_entity.dart';
import 'package:project_gofull/features/requests/domain/entities/service_request_entity.dart';

abstract class ProviderState extends Equatable {
  const ProviderState();
  @override
  List<Object?> get props => [];
}

class ProviderInitial extends ProviderState {
  const ProviderInitial();
}

class ProviderLoading extends ProviderState {
  const ProviderLoading();
}

class ProfileLoaded extends ProviderState {
  final ProviderProfileEntity profile;
  const ProfileLoaded(this.profile);
  @override
  List<Object?> get props => [profile];
}

class AvailabilityUpdated extends ProviderState {
  final bool isAvailable;
  const AvailabilityUpdated(this.isAvailable);
  @override
  List<Object?> get props => [isAvailable];
}

class PendingRequestsLoaded extends ProviderState {
  final List<ServiceRequestEntity> requests;
  const PendingRequestsLoaded(this.requests);
  @override
  List<Object?> get props => [requests];
}

class HistoryLoaded extends ProviderState {
  final List<ServiceRequestEntity> requests;
  const HistoryLoaded(this.requests);
  @override
  List<Object?> get props => [requests];
}

class RequestAccepted extends ProviderState {
  final ServiceRequestEntity request;
  const RequestAccepted(this.request);
  @override
  List<Object?> get props => [request];
}

class RequestRejected extends ProviderState {
  const RequestRejected();
}

class StatusUpdated extends ProviderState {
  final ServiceRequestEntity request;
  const StatusUpdated(this.request);
  @override
  List<Object?> get props => [request];
}

class DriverRated extends ProviderState {
  final RatingEntity rating;
  const DriverRated(this.rating);
  @override
  List<Object?> get props => [rating];
}

class ActiveRequestLoaded extends ProviderState {
  final ServiceRequestEntity? request;
  const ActiveRequestLoaded(this.request);
  @override
  List<Object?> get props => [request];
}

class ProviderError extends ProviderState {
  final String message;
  const ProviderError(this.message);
  @override
  List<Object?> get props => [message];
}
