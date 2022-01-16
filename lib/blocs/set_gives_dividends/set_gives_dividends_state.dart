part of 'set_gives_dividends_cubit.dart';

abstract class SetGivesDividendsState extends Equatable {
  const SetGivesDividendsState();

  @override
  List<Object> get props => [];
}

class SetGivesDividendsInitial extends SetGivesDividendsState {}

class SetGivesDividendsLoading extends SetGivesDividendsState {
  const SetGivesDividendsLoading();
}

class SetGivesDividendsFailure extends SetGivesDividendsState {
  final String msg;

  const SetGivesDividendsFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class SetGivesDividendsSuccess extends SetGivesDividendsState {
  final stockID;
  final bool givesDividends;

  const SetGivesDividendsSuccess(this.stockID, this.givesDividends);
}
