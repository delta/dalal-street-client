part of 'leaderboard_cubit.dart';

abstract class LeaderboardState extends Equatable {
  const LeaderboardState();

  @override
  List<Object> get props => [];
}

class LeaderboardInitial extends LeaderboardState {}

class DailyLeaderboardSuccess extends LeaderboardState {
  final int myRank;
  final List<DailyLeaderboardRow> rankList;
  final int totalUsers;
  const DailyLeaderboardSuccess(this.myRank, this.rankList, this.totalUsers);

  @override
  List<Object> get props => [myRank, rankList];
}

class LeaderboardLoading extends LeaderboardState {
  const LeaderboardLoading();
}

class OverallLeaderboardSuccess extends LeaderboardState {
  final int myRank;
  final List<LeaderboardRow> rankList;
  final int totalUsers;
  const OverallLeaderboardSuccess(this.myRank, this.rankList, this.totalUsers);

  @override
  List<Object> get props => [myRank, rankList];
}

class LeaderboardFailure extends LeaderboardState {
  final String statusMessage;
  const LeaderboardFailure(this.statusMessage);

  @override
  List<Object> get props => [statusMessage];
}
