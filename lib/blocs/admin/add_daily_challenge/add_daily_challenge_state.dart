part of 'add_daily_challenge_cubit.dart';

abstract class AddDailyChallengeState extends Equatable {
  const AddDailyChallengeState();

  @override
  List<Object> get props => [];
}

class AddDailyChallengeInitial extends AddDailyChallengeState {}

class AddDailyChallengeLoading extends AddDailyChallengeState {
  const AddDailyChallengeLoading();
}

class AddDailyChallengeFailure extends AddDailyChallengeState {
  final String msg;

  const AddDailyChallengeFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class AddDailyChallengeSuccess extends AddDailyChallengeState {
  final String msg;

  const AddDailyChallengeSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}
