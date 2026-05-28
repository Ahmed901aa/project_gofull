import 'package:equatable/equatable.dart';
import 'package:project_gofull/features/notifications/data/datasources/notification_data_source.dart';
import 'package:project_gofull/features/notifications/domain/entities/notification_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object?> get props => [];
}

class LoadNotificationsEvent extends NotificationEvent {
  const LoadNotificationsEvent();
}

// States
abstract class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

class NotificationsLoaded extends NotificationState {
  final List<NotificationEntity> notifications;
  const NotificationsLoaded(this.notifications);
  @override
  List<Object?> get props => [notifications];
}

class NotificationError extends NotificationState {
  final String message;
  const NotificationError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationDataSource dataSource;

  NotificationBloc({required this.dataSource}) : super(const NotificationInitial()) {
    on<LoadNotificationsEvent>(_onLoad);
  }

  Future<void> _onLoad(LoadNotificationsEvent e, Emitter<NotificationState> emit) async {
    emit(const NotificationLoading());
    try {
      final list = await dataSource.getNotifications();
      emit(NotificationsLoaded(list));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}
