part of 'notifications_cubit.dart';

abstract class NotificationsCubitState extends Equatable {
  const NotificationsCubitState();

  @override
  List<Object> get props => [];
}

class NotificationsCubitInitial extends NotificationsCubitState {}

class GetNotificationSuccess extends NotificationsCubitState {
  final List<Notification> notifications;
  const GetNotificationSuccess(this.notifications);
  @override
  List<Object> get props => [notifications];
}

class GetNotificationFailure extends NotificationsCubitState {
  final String error;
  const GetNotificationFailure(this.error);
  @override
  List<Object> get props => [error];
}
