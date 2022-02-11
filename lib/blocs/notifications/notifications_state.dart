part of 'notifications_bloc.dart';

abstract class NotifState extends Equatable {
  const NotifState();
  @override
  List<Object> get props => [];
}

class NotifInitial extends NotifState {}

class GetNotifSuccess extends NotifState {
  final GetNotificationsResponse getNotifResponse;
  const GetNotifSuccess(this.getNotifResponse);
  @override
  List<Object> get props => [getNotifResponse];
}

class GetNotifFailure extends NotifState {
  final String error;
  const GetNotifFailure(this.error);
  @override
  List<Object> get props => [error];
}
