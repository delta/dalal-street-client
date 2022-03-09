part of 'market_event_cubit.dart';

abstract class MarketEventState extends Equatable {
  const MarketEventState();

  @override
  List<Object> get props => [];
}

class MarketEventInitial extends MarketEventState {}

class MarketEventSuccess extends MarketEventState {
  final List<MarketEvent> marketEvents;

  const MarketEventSuccess(this.marketEvents);

  @override
  List<Object> get props => [marketEvents];
}

class MarketEventFailure extends MarketEventState {
  final String message;

  const MarketEventFailure(this.message);

  @override
  List<Object> get props => [message];
}
