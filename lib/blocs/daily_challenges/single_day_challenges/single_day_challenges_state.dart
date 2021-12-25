part of 'single_day_challenges_cubit.dart';

abstract class SingleDayChallengesState extends Equatable {
  const SingleDayChallengesState();

  @override
  List<Object> get props => [];
}

class SingleDayChallengesLoading extends SingleDayChallengesState {}

class SingleDayChallengesLoaded extends SingleDayChallengesState {
  final List<DailyChallengeInfo> challengeInfos;

  const SingleDayChallengesLoaded(this.challengeInfos);

  @override
  List<Object> get props => [challengeInfos];
}

class SingleDayChallengesFailure extends SingleDayChallengesState {
  final String msg;

  const SingleDayChallengesFailure(this.msg);

  @override
  List<Object> get props => [msg];
}
