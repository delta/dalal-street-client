part of 'notification_cubit.dart';

abstract class NotificationStreamState extends Equatable {
  const NotificationStreamState();

  @override
  List<Object> get props => [];
}

class NotificationStreamLoading extends NotificationStreamState {}

class NotificationStreamSuccess extends NotificationStreamState {}

class NotificationStreamUpdate extends NotificationStreamState {
  final Notification notification;

  const NotificationStreamUpdate(this.notification);
}

class NotificationStreamError extends NotificationStreamState {
  final String message;

  const NotificationStreamError(this.message);
}
