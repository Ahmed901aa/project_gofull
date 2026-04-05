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
