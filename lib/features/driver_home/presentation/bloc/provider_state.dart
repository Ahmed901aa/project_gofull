import 'package:equatable/equatable.dart';
import 'package:project_gofull/features/driver_home/data/models/provider_profile_model.dart';
import 'package:project_gofull/features/driver_home/data/models/service_request_model.dart';

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

class ProviderLoginSuccess extends ProviderState {
  final String token;
  final String userName;
  const ProviderLoginSuccess({required this.token, required this.userName});
  @override
  List<Object?> get props => [token, userName];
}

class ProviderProfileLoaded extends ProviderState {
  final ProviderProfileModel profile;
  const ProviderProfileLoaded(this.profile);
  @override
  List<Object?> get props => [profile];
}

class ProviderAvailabilityUpdated extends ProviderState {
  final bool isAvailable;
  const ProviderAvailabilityUpdated(this.isAvailable);
  @override
  List<Object?> get props => [isAvailable];
}

class ProviderPendingRequestsLoaded extends ProviderState {
  final List<ServiceRequestModel> requests;
  const ProviderPendingRequestsLoaded(this.requests);
  @override
  List<Object?> get props => [requests];
}

class ProviderOrderHistoryLoaded extends ProviderState {
  final List<ServiceRequestModel> orders;
  const ProviderOrderHistoryLoaded(this.orders);
  @override
  List<Object?> get props => [orders];
}

class ProviderRequestAccepted extends ProviderState {
  final ServiceRequestModel request;
  const ProviderRequestAccepted(this.request);
  @override
  List<Object?> get props => [request];
}

class ProviderRequestRejected extends ProviderState {
  const ProviderRequestRejected();
}

class ProviderRequestStatusUpdated extends ProviderState {
  final ServiceRequestModel request;
  const ProviderRequestStatusUpdated(this.request);
  @override
  List<Object?> get props => [request];
}

class ProviderRatingSubmitted extends ProviderState {
  const ProviderRatingSubmitted();
}

class ProviderLoggedOut extends ProviderState {
  const ProviderLoggedOut();
}

class ProviderError extends ProviderState {
  final String message;
  const ProviderError(this.message);
  @override
  List<Object?> get props => [message];
}
