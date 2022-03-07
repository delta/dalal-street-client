part of 'resend_mail_cubit.dart';

abstract class ResendMailState extends Equatable {
  const ResendMailState();

  @override
  List<Object> get props => [];
}

class ResendMailInitial extends ResendMailState {}

class ResendMailLoading extends ResendMailState {}

class ResendMailSuccess extends ResendMailState {
  final String msg;

  const ResendMailSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}

class ResendMailFailure extends ResendMailState {
  final String msg;

  const ResendMailFailure(this.msg);

  @override
  List<Object> get props => [msg];
}
