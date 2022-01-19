part of 'referral_cubit.dart';

abstract class ReferralState extends Equatable {
  const ReferralState();

  @override
  List<Object> get props => [];
}

class ReferralInitial extends ReferralState {}

class ReferralSuccess extends ReferralState {
  final String referralcode;
  const ReferralSuccess(this.referralcode);
}

class ReferralFailed extends ReferralState {
  final String msg;
  const ReferralFailed(this.msg);
}
