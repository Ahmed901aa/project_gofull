import 'package:equatable/equatable.dart';

abstract class ProviderEvent extends Equatable {
  const ProviderEvent();
  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProviderEvent {
  const LoadProfileEvent();
}

class ToggleAvailabilityEvent extends ProviderEvent {
  final bool isAvailable;
  const ToggleAvailabilityEvent(this.isAvailable);
  @override
  List<Object?> get props => [isAvailable];
}

class LoadPendingRequestsEvent extends ProviderEvent {
  const LoadPendingRequestsEvent();
}

class LoadHistoryEvent extends ProviderEvent {
  const LoadHistoryEvent();
}

class AcceptRequestEvent extends ProviderEvent {
  final int id;
  const AcceptRequestEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class RejectRequestEvent extends ProviderEvent {
  final int id;
  const RejectRequestEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class UpdateStatusEvent extends ProviderEvent {
  final int id;
  final String status;
  const UpdateStatusEvent({required this.id, required this.status});
  @override
  List<Object?> get props => [id, status];
}

class LoadActiveRequestEvent extends ProviderEvent {
  const LoadActiveRequestEvent();
}

class RateDriverEvent extends ProviderEvent {
  final int requestId;
  final int rating;
  final String? comment;
  const RateDriverEvent({required this.requestId, required this.rating, this.comment});
  @override
  List<Object?> get props => [requestId, rating, comment];
}
