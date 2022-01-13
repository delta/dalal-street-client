part of 'challenge_reward_cubit.dart';

abstract class ChallengeRewardState extends Equatable {
  const ChallengeRewardState();

  @override
  List<Object> get props => [];
}

class ChallengeIncomplete extends ChallengeRewardState {
  const ChallengeIncomplete();
}

class ChallengeComplete extends ChallengeRewardState {
  const ChallengeComplete();
}

class ChallengeRewardLoading extends ChallengeRewardState {
  const ChallengeRewardLoading();
}

class ChallengeRewardFailure extends ChallengeRewardState {
  final String msg;

  const ChallengeRewardFailure(this.msg);
}

class ChallengeRewardClaimed extends ChallengeRewardState {
  final int reward;

  const ChallengeRewardClaimed(this.reward);
}
