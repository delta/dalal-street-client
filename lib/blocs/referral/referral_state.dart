part of 'referral_cubit.dart';

abstract class ReferralState extends Equatable {
  const ReferralState();

  @override
  List<Object> get props => [];
}

class ReferralInitial extends ReferralState {}

class ReferralSuccess extends ReferralState {
  final String referralCode;
  const ReferralSuccess(this.referralCode);
  @override
  List<Object> get props => [referralCode];
}

class ReferralFailed extends ReferralState {
  final String msg;
  const ReferralFailed(this.msg);
  @override
  List<Object> get props => [msg];
}
class RemoveButtonSucess extends ReferralState
{
  const RemoveButtonSucess();
}
