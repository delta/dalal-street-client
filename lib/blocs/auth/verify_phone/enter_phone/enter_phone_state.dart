part of 'enter_phone_cubit.dart';

abstract class EnterPhoneState extends Equatable {
  const EnterPhoneState();

  @override
  List<Object> get props => [];
}

class EnterPhoneInitial extends EnterPhoneState {
  const EnterPhoneInitial();
}

class EnterPhoneLoading extends EnterPhoneState {
  const EnterPhoneLoading();
}

class EnterPhoneFailure extends EnterPhoneState {
  final String msg;

  const EnterPhoneFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class EnterPhoneSuccess extends EnterPhoneState {
  final String phone;

  const EnterPhoneSuccess(this.phone);

  @override
  List<Object> get props => [phone];
}
