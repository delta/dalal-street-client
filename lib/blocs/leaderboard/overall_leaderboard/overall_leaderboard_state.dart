part of 'overall_leaderboard_cubit.dart';

abstract class OverallLeaderboardState extends Equatable {
  const OverallLeaderboardState();

  @override
  List<Object> get props => [];
}

class OverallLeaderboardInitial extends OverallLeaderboardState {}

class OverallLeaderboardLoading extends OverallLeaderboardState {
  const OverallLeaderboardLoading();
}

class OverallLeaderboardSuccess extends OverallLeaderboardState {
  final int myRank;
  final Iterable<LeaderboardRow> rankList;
  const OverallLeaderboardSuccess(this.myRank, this.rankList);

  @override
  List<Object> get props => [myRank, rankList];
}

class OverallLeaderboardFailure extends OverallLeaderboardState {
  final String statusMessage;
  const OverallLeaderboardFailure(this.statusMessage);

  @override
  List<Object> get props => [statusMessage];
}
