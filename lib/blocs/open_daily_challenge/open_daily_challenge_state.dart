part of 'open_daily_challenge_cubit.dart';

abstract class OpenDailyChallengeState extends Equatable {
  const OpenDailyChallengeState();

  @override
  List<Object> get props => [];
}

class OpenDailyChallengeInitial extends OpenDailyChallengeState {}

class OpenDailyChallengeLoading extends OpenDailyChallengeState {
  const OpenDailyChallengeLoading();
}

class OpenDailyChallengeFailure extends OpenDailyChallengeState {
  final String msg;

  const OpenDailyChallengeFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class OpenDailyChallengeSuccess extends OpenDailyChallengeState {
  const OpenDailyChallengeSuccess();
}
