part of 'close_daily_challenge_cubit.dart';

abstract class CloseDailyChallengeState extends Equatable {
  const CloseDailyChallengeState();

  @override
  List<Object> get props => [];
}

class CloseDailyChallengeInitial extends CloseDailyChallengeState {}

class CloseDailyChallengeLoading extends CloseDailyChallengeState {
  const CloseDailyChallengeLoading();
}

class CloseDailyChallengeFailure extends CloseDailyChallengeState {
  final String msg;

  const CloseDailyChallengeFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class CloseDailyChallengeSuccess extends CloseDailyChallengeState {
  final String msg;

  const CloseDailyChallengeSuccess(this.msg);
  @override
  List<Object> get props => [msg];
}
