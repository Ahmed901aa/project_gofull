import 'package:equatable/equatable.dart';

abstract class ProviderEvent extends Equatable {
  const ProviderEvent();
  @override
  List<Object?> get props => [];
}

class LoadProfileRequested extends ProviderEvent {
  const LoadProfileRequested();
}

class ToggleAvailabilityRequested extends ProviderEvent {
  final bool isAvailable;
  const ToggleAvailabilityRequested(this.isAvailable);
  @override
  List<Object?> get props => [isAvailable];
}

class LoadPendingRequestsRequested extends ProviderEvent {
  const LoadPendingRequestsRequested();
}

class LoadOrderHistoryRequested extends ProviderEvent {
  final int page;
  const LoadOrderHistoryRequested({this.page = 1});
  @override
  List<Object?> get props => [page];
}

class AcceptRequestRequested extends ProviderEvent {
  final int requestId;
  const AcceptRequestRequested(this.requestId);
  @override
  List<Object?> get props => [requestId];
}

class RejectRequestRequested extends ProviderEvent {
  final int requestId;
  const RejectRequestRequested(this.requestId);
  @override
  List<Object?> get props => [requestId];
}

class UpdateRequestStatusRequested extends ProviderEvent {
  final int requestId;
  final String status;
  const UpdateRequestStatusRequested(this.requestId, this.status);
  @override
  List<Object?> get props => [requestId, status];
}

class RateCustomerRequested extends ProviderEvent {
  final int requestId;
  final int rating;
  final String? comment;
  const RateCustomerRequested(this.requestId, this.rating, this.comment);
  @override
  List<Object?> get props => [requestId, rating, comment];
}

class LoginRequested extends ProviderEvent {
  final String phone;
  final String password;
  const LoginRequested(this.phone, this.password);
  @override
  List<Object?> get props => [phone, password];
}

class LogoutRequested extends ProviderEvent {
  const LogoutRequested();
}
