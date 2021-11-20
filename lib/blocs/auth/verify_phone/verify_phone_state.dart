part of 'verify_phone_cubit.dart';

abstract class VerifyPhoneState extends Equatable {
  const VerifyPhoneState();

  @override
  List<Object> get props => [];
}

class EnteringPhone extends VerifyPhoneState {
  const EnteringPhone();
}

class VerifyPhoneLoading extends VerifyPhoneState {
  const VerifyPhoneLoading();
}

class VerifyPhoneFailure extends VerifyPhoneState {
  final String msg;

  const VerifyPhoneFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class EnteringOTP extends VerifyPhoneState {
  final String phone;

  const EnteringOTP(this.phone);

  @override
  List<Object> get props => [phone];
}

class VerifyPhoneSuccess extends VerifyPhoneState {
  const VerifyPhoneSuccess();
}
