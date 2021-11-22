part of 'enter_otp_cubit.dart';

abstract class EnterOtpState extends Equatable {
  const EnterOtpState();

  @override
  List<Object> get props => [];
}

class EnterOtpInitial extends EnterOtpState {
  final String phone;

  const EnterOtpInitial(this.phone);

  @override
  List<Object> get props => [phone];
}

class EnterOtpLoading extends EnterOtpState {
  const EnterOtpLoading();
}

class EnterOtpFailure extends EnterOtpState {
  final String msg;

  const EnterOtpFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class EnterOtpSuccess extends EnterOtpState {
  const EnterOtpSuccess();
}
