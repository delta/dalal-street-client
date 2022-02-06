part of 'notifications_cubit.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

class NotificationsFailure extends NotificationsState {
  final String msg;

  const NotificationsFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class NotificationsSuccess extends NotificationsState {
  final String msg;

  const NotificationsSuccess(this.msg);
}
