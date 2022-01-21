part of 'referral_bloc.dart';

abstract class ReferralEvent extends Equatable {
  const ReferralEvent();

  @override
  List<Object> get props => [];
}

class GetReferralCode extends ReferralEvent {
  final String email;
  const GetReferralCode(this.email);
  @override
  List<Object> get props => [email];
}
