import 'package:equatable/equatable.dart';

abstract class AppConfigEvent extends Equatable {
  const AppConfigEvent();
  @override
  List<Object?> get props => [];
}

class LoadAppConfigEvent extends AppConfigEvent {
  const LoadAppConfigEvent();
}

class LoadHomeDataEvent extends AppConfigEvent {
  const LoadHomeDataEvent();
}

/// Internal — fired when a `home.data.updated` frame arrives on the
/// `home-data` Reverb channel. Carries the raw broadcast payload.
class RealtimeHomeDataEvent extends AppConfigEvent {
  final Map<String, dynamic> payload;
  const RealtimeHomeDataEvent(this.payload);

  @override
  List<Object?> get props => [payload];
}
