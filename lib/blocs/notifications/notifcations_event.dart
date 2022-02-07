part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class GetNotifications extends NotificationsEvent {
  const GetNotifications();
}

class GetMoreNotifications extends NotificationsEvent {
  final int lastnotificationid;
  const GetMoreNotifications(this.lastnotificationid);
  @override
  List<Object> get props => [lastnotificationid];
}
