part of 'daily_challenges_page_cubit.dart';

abstract class DailyChallengesPageState extends Equatable {
  const DailyChallengesPageState();

  @override
  List<Object> get props => [];
}

class DailyChallengesPageLoading extends DailyChallengesPageState {}

class DailyChallengesPageSuccess extends DailyChallengesPageState {
  final int marketDay;
  final int totalMarketDays;

  const DailyChallengesPageSuccess(
    this.marketDay,
    this.totalMarketDays,
  );

  @override
  List<Object> get props => [marketDay, totalMarketDays];
}

class DailyChallengesPageFailure extends DailyChallengesPageState {
  final String msg;

  const DailyChallengesPageFailure(this.msg);

  @override
  List<Object> get props => [msg];
}
