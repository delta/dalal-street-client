part of 'notifications_cubit.dart';

abstract class NotificationsCubitState extends Equatable {
  const NotificationsCubitState();

  @override
  List<Object> get props => [];

  get lastnotificationid => null;
}

class NotificationsCubitInitial extends NotificationsCubitState {}

class GetNotifSuccess extends NotificationsCubitState {
  final GetNotificationsResponse getNotifResponse;
  const GetNotifSuccess(this.getNotifResponse);
  @override
  List<Object> get props => [getNotifResponse];
}

class GetNotifFailure extends NotificationsCubitState {
  final String error;
  const GetNotifFailure(this.error);
  @override
  List<Object> get props => [error];
}

class GetMoreNotifications extends NotificationsCubitState {
  @override
  final int lastnotificationid;
  const GetMoreNotifications(this.lastnotificationid);
  @override
  List<Object> get props => [lastnotificationid];
}
