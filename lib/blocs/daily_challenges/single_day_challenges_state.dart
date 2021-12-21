part of 'single_day_challenges_cubit.dart';

abstract class SingleDayChallengesState extends Equatable {
  const SingleDayChallengesState();

  @override
  List<Object> get props => [];
}

class DailyChallengesLoading extends SingleDayChallengesState {}

class DailyChallengesLoaded extends SingleDayChallengesState {
  final List<DailyChallenge> challenges;

  const DailyChallengesLoaded(this.challenges);
}

class DailyChallengesFailure extends SingleDayChallengesState {
  final String msg;

  const DailyChallengesFailure(this.msg);

  @override
  List<Object> get props => [msg];
}
