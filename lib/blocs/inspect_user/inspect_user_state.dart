part of 'inspect_user_cubit.dart';

abstract class InspectUserState extends Equatable {
  const InspectUserState();

  @override
  List<Object> get props => [];
}

class InspectUserInitial extends InspectUserState {}

class InspectUserLoading extends InspectUserState {
  const InspectUserLoading();
}

class InspectUserFailure extends InspectUserState {
  final String msg;

  const InspectUserFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class InspectUserSuccess extends InspectUserState {
  final user_id;
  final transactionType;
  final day;
  const InspectUserSuccess(this.user_id, this.transactionType, this.day);
}
