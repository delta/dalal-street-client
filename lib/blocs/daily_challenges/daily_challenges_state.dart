part of 'daily_challenges_cubit.dart';

abstract class DailyChallengesState extends Equatable {
  const DailyChallengesState();

  @override
  List<Object> get props => [];
}

class DailyChallengesLoading extends DailyChallengesState {}

class DailyChallengesLoaded extends DailyChallengesState {}

class DailyChallengesFailure extends DailyChallengesState {
  final String msg;

  const DailyChallengesFailure(this.msg);

  @override
  List<Object> get props => [msg];
}
