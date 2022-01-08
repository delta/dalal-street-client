part of 'send_notifications_cubit.dart';

abstract class SendNotificationsState extends Equatable {
  const SendNotificationsState();

  @override
  List<Object> get props => [];
}

class SendNotificationsInitial extends SendNotificationsState {}

class SendNotificationsLoading extends SendNotificationsState {
  const SendNotificationsLoading();
}

class SendNotificationsFailure extends SendNotificationsState {
  final String msg;

  const SendNotificationsFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class SendNotificationsSuccess extends SendNotificationsState {
  final int user_id;
  final String text;
  final bool isGlobal;

  const SendNotificationsSuccess(this.user_id, this.text, this.isGlobal);
}
