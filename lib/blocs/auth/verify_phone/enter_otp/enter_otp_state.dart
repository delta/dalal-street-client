part of 'enter_otp_cubit.dart';

abstract class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object> get props => [];
}

class OtpInitial extends OtpState {
  final String phone;

  const OtpInitial(this.phone);

  @override
  List<Object> get props => [phone];
}

class OtpLoading extends OtpState {
  const OtpLoading();
}

class OtpFailure extends OtpState {
  final String msg;

  const OtpFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class OtpResent extends OtpState {
  const OtpResent();
}

class OtpSuccess extends OtpState {
  const OtpSuccess();
}
