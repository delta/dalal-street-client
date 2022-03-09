part of 'market_events_stream_cubit.dart';

abstract class MarketEventsStreamState extends Equatable {
  const MarketEventsStreamState();

  @override
  List<Object> get props => [];
}

class MarketEventsStreamInitial extends MarketEventsStreamState {}

class MarketEventsStreamUpdate extends MarketEventsStreamState {
  final MarketEvent marketEvent;

  const MarketEventsStreamUpdate(this.marketEvent);

  @override
  List<Object> get props => [marketEvent];
}

class MarketEventsStreamError extends MarketEventsStreamState {
  final String message;

  const MarketEventsStreamError(this.message);

  @override
  List<Object> get props => [message];
}
