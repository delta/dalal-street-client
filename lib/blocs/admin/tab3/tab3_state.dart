part of 'tab3_cubit.dart';

abstract class Tab3State extends Equatable {
  const Tab3State();

  @override
  List<Object> get props => [];
}

class Tab3Initial extends Tab3State {}

abstract class UpdateEndOfDayValuesState extends Equatable {
  const UpdateEndOfDayValuesState();

  @override
  List<Object> get props => [];
}

class UpdateEndOfDayValuesInitial extends Tab3State {}

class UpdateEndOfDayValuesLoading extends Tab3State {
  const UpdateEndOfDayValuesLoading();
}

class UpdateEndOfDayValuesFailure extends Tab3State {
  final String msg;

  const UpdateEndOfDayValuesFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class UpdateEndOfDayValuesSuccess extends Tab3State {
  final String msg;

  const UpdateEndOfDayValuesSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}

abstract class UpdateStockPriceState extends Equatable {
  const UpdateStockPriceState();

  @override
  List<Object> get props => [];
}

class UpdateStockPriceInitial extends Tab3State {}

class UpdateStockPriceLoading extends Tab3State {
  const UpdateStockPriceLoading();
}

class UpdateStockPriceFailure extends Tab3State {
  final String msg;

  const UpdateStockPriceFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class UpdateStockPriceSuccess extends Tab3State {
  final String msg;

  const UpdateStockPriceSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}

abstract class AddStocksToExchangeState extends Equatable {
  const AddStocksToExchangeState();

  @override
  List<Object> get props => [];
}

class AddStocksToExchangeInitial extends Tab3State {}

class AddStocksToExchangeLoading extends Tab3State {
  const AddStocksToExchangeLoading();
}

class AddStocksToExchangeFailure extends Tab3State {
  final String msg;

  const AddStocksToExchangeFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class AddStocksToExchangeSuccess extends Tab3State {
  final String msg;

  const AddStocksToExchangeSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}

abstract class AddMarketEventState extends Equatable {
  const AddMarketEventState();

  @override
  List<Object> get props => [];
}

class AddMarketEventInitial extends Tab3State {}

class AddMarketEventLoading extends Tab3State {
  const AddMarketEventLoading();
}

class AddMarketEventFailure extends Tab3State {
  final String msg;

  const AddMarketEventFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class AddMarketEventSuccess extends Tab3State {
  final String msg;

  const AddMarketEventSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}

abstract class AddDailyChallengeState extends Equatable {
  const AddDailyChallengeState();

  @override
  List<Object> get props => [];
}

class AddDailyChallengeInitial extends Tab3State {}

class AddDailyChallengeLoading extends Tab3State {
  const AddDailyChallengeLoading();
}

class AddDailyChallengeFailure extends Tab3State {
  final String msg;

  const AddDailyChallengeFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class AddDailyChallengeSuccess extends Tab3State {
  final String msg;

  const AddDailyChallengeSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}

abstract class OpenDailyChallengeState extends Equatable {
  const OpenDailyChallengeState();

  @override
  List<Object> get props => [];
}

class OpenDailyChallengeInitial extends Tab3State {}

class OpenDailyChallengeLoading extends Tab3State {
  const OpenDailyChallengeLoading();
}

class OpenDailyChallengeFailure extends Tab3State {
  final String msg;

  const OpenDailyChallengeFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class OpenDailyChallengeSuccess extends Tab3State {
  final String msg;

  const OpenDailyChallengeSuccess(this.msg);

  @override
  List<Object> get props => [msg];
}

abstract class CloseDailyChallengeState extends Equatable {
  const CloseDailyChallengeState();

  @override
  List<Object> get props => [];
}

class CloseDailyChallengeInitial extends Tab3State {}

class CloseDailyChallengeLoading extends Tab3State {
  const CloseDailyChallengeLoading();
}

class CloseDailyChallengeFailure extends Tab3State {
  final String msg;

  const CloseDailyChallengeFailure(this.msg);

  @override
  List<Object> get props => [msg];
}

class CloseDailyChallengeSuccess extends Tab3State {
  final String msg;

  const CloseDailyChallengeSuccess(this.msg);
  @override
  List<Object> get props => [msg];
}
