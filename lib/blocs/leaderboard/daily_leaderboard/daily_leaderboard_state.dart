part of 'daily_leaderboard_cubit.dart';

abstract class DailyLeaderboardState extends Equatable {
  const DailyLeaderboardState();

  @override
  List<Object> get props => [];
}

class DailyLeaderboardInitial extends DailyLeaderboardState {}

class DailyLeaderboardLoading extends DailyLeaderboardState {
  const DailyLeaderboardLoading();
}

class DailyLeaderboardSuccess extends DailyLeaderboardState {
  final int myRank;
  final Iterable<DailyLeaderboardRow> rankList;
  const DailyLeaderboardSuccess(this.myRank, this.rankList);

  @override
  List<Object> get props => [myRank, rankList];
}

class DailyLeaderboardFailure extends DailyLeaderboardState {
  final String statusMessage;
  const DailyLeaderboardFailure(this.statusMessage);

  @override
  List<Object> get props => [statusMessage];
}
