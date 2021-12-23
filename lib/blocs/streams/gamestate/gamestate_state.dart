part of 'gamestate_cubit.dart';

abstract class GamestateStreamState extends Equatable {
  const GamestateStreamState();

  @override
  List<Object> get props => [];
}

class GamestateStreamLoading extends GamestateStreamState {}

class GamestateStreamSuccess extends GamestateStreamState {}

class GamestateStreamUpdate extends GamestateStreamState {
  final GameStateUpdateType gameStateUpdateType;
  final GameState gamestate;

  const GamestateStreamUpdate(this.gamestate, this.gameStateUpdateType);
}

class GamestateStreamError extends GamestateStreamState {
  final String message;

  const GamestateStreamError(this.message);
}
