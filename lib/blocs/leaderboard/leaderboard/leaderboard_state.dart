part of 'leaderboard_cubit.dart';

abstract class LeaderboardState extends Equatable {
  const LeaderboardState();

  @override
  List<Object> get props => [];
}

class LeaderboardInitial extends LeaderboardState {}

abstract class DailyLeaderboardState extends Equatable {
  const DailyLeaderboardState();

  @override
  List<Object> get props => [];
}

class DailyLeaderboardInitial extends LeaderboardState {}

class DailyLeaderboardLoading extends LeaderboardState {
  const DailyLeaderboardLoading();
}

class DailyLeaderboardSuccess extends LeaderboardState {
  final int myRank;
  final Iterable<DailyLeaderboardRow> rankList;
  const DailyLeaderboardSuccess(this.myRank, this.rankList);

  @override
  List<Object> get props => [myRank, rankList];
}

class DailyLeaderboardFailure extends LeaderboardState {
  final String statusMessage;
  const DailyLeaderboardFailure(this.statusMessage);

  @override
  List<Object> get props => [statusMessage];
}

abstract class OverallLeaderboardState extends Equatable {
  const OverallLeaderboardState();

  @override
  List<Object> get props => [];
}

class OverallLeaderboardInitial extends LeaderboardState {}

class OverallLeaderboardLoading extends LeaderboardState {
  const OverallLeaderboardLoading();
}

class OverallLeaderboardSuccess extends LeaderboardState {
  final int myRank;
  final Iterable<LeaderboardRow> rankList;
  const OverallLeaderboardSuccess(this.myRank, this.rankList);

  @override
  List<Object> get props => [myRank, rankList];
}

class OverallLeaderboardFailure extends LeaderboardState {
  final String statusMessage;
  const OverallLeaderboardFailure(this.statusMessage);

  @override
  List<Object> get props => [statusMessage];
}
